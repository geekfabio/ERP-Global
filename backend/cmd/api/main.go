package main

import (
 "context"
 "log/slog"
 "os"
 "os/signal"
 "syscall"
 "time"

 "github.com/geekfabio/ERP-Global/backend/internal/config"
 "github.com/geekfabio/ERP-Global/backend/internal/platform/httpserver"
)

func main() {
 logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
 cfg := config.FromEnv()
 ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
 defer stop()
 server, cleanup, err := httpserver.New(ctx, cfg, logger)
 if err != nil { logger.Error("startup failed", "error", err); os.Exit(1) }
 defer cleanup()
 go func() {
  if err := server.ListenAndServe(); err != nil && err != httpserver.ErrServerClosed {
   logger.Error("server failed", "error", err)
   stop()
  }
 }()
 logger.Info("api listening", "address", server.Addr)
 <-ctx.Done()
 shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
 defer cancel()
 if err := server.Shutdown(shutdownCtx); err != nil { logger.Error("shutdown failed", "error", err) }
}
