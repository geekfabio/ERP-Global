package httpserver

import (
 "log/slog"
 "net/http"
 "time"

 "github.com/gin-gonic/gin"
 "github.com/geekfabio/ERP-Global/backend/internal/config"
 "github.com/geekfabio/ERP-Global/backend/internal/schema"
)

var ErrServerClosed = http.ErrServerClosed

func Router() http.Handler {
 gin.SetMode(gin.ReleaseMode)
 r := gin.New()
 r.Use(gin.Recovery())
 r.GET("/health/live",func(c *gin.Context){c.JSON(http.StatusOK,gin.H{"status":"ok"})})
 r.GET("/health/ready",func(c *gin.Context){c.JSON(http.StatusOK,gin.H{"status":"ok","storage":"memory","databaseConnected":false})})
 r.GET("/v1/meta/schema",func(c *gin.Context){c.JSON(http.StatusOK,gin.H{"data":schema.Catalog()})})
 return r
}
func New(cfg config.Config, logger *slog.Logger) *http.Server {
 return &http.Server{
  Addr:cfg.Address, Handler:Router(),
  ReadHeaderTimeout:5*time.Second, ReadTimeout:15*time.Second,
  WriteTimeout:15*time.Second, IdleTimeout:60*time.Second,
  ErrorLog:slog.NewLogLogger(logger.Handler(),slog.LevelError),
 }
}
