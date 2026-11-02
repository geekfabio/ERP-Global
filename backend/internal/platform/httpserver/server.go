package httpserver

import (
 "context"
 "errors"
 "log/slog"
 "net/http"
 "time"

 "github.com/gin-gonic/gin"
 "github.com/jackc/pgx/v5/pgxpool"
 "github.com/geekfabio/ERP-Global/backend/internal/config"
)

var ErrServerClosed = http.ErrServerClosed

type databasePinger interface { Ping(context.Context) error }

func Router(db databasePinger) http.Handler {
 gin.SetMode(gin.ReleaseMode)
 r := gin.New()
 r.Use(gin.Recovery())
 r.GET("/health/live", func(c *gin.Context) { c.JSON(http.StatusOK, gin.H{"status":"ok"}) })
 r.GET("/health/ready", func(c *gin.Context) {
  ctx, cancel := context.WithTimeout(c.Request.Context(), 2*time.Second)
  defer cancel()
  if err := db.Ping(ctx); err != nil {
   c.JSON(http.StatusServiceUnavailable, gin.H{"error":gin.H{"code":"SERVICE_UNAVAILABLE","message":"Base de dados indisponível"}})
   return
  }
  c.JSON(http.StatusOK, gin.H{"status":"ok"})
 })
 return r
}

func New(ctx context.Context, cfg config.Config, logger *slog.Logger) (*http.Server, func(), error) {
 if cfg.DatabaseURL == "" { return nil, nil, errors.New("DATABASE_URL is required") }
 pool, err := pgxpool.New(ctx, cfg.DatabaseURL)
 if err != nil { return nil, nil, err }
 pingCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
 defer cancel()
 if err := pool.Ping(pingCtx); err != nil { pool.Close(); return nil, nil, err }
 server := &http.Server{
  Addr:cfg.Address,
  Handler:Router(pool),
  ReadHeaderTimeout:5*time.Second,
  ReadTimeout:15*time.Second,
  WriteTimeout:15*time.Second,
  IdleTimeout:60*time.Second,
  ErrorLog:slog.NewLogLogger(logger.Handler(), slog.LevelError),
 }
 return server, pool.Close, nil
}
