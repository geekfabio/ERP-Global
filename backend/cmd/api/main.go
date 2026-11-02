package main

import (
 "context"
 "log/slog"
 "net/http"
 "os"
 "os/signal"
 "syscall"
 "time"

 "github.com/geekfabio/ERP-Global/backend/internal/config"
 "github.com/geekfabio/ERP-Global/backend/internal/platform/httpserver"
)

func main() {
 logger:=slog.New(slog.NewJSONHandler(os.Stdout,nil))
 server:=httpserver.New(config.FromEnv(),logger)
 ctx,stop:=signal.NotifyContext(context.Background(),syscall.SIGINT,syscall.SIGTERM)
 defer stop()
 go func(){
  if err:=server.ListenAndServe();err!=nil&&err!=http.ErrServerClosed{
   logger.Error("http failed","error",err)
   stop()
  }
 }()
 logger.Info("api started","address",server.Addr,"storage","memory")
 <-ctx.Done()
 shutdownCtx,cancel:=context.WithTimeout(context.Background(),10*time.Second)
 defer cancel()
 if err:=server.Shutdown(shutdownCtx);err!=nil{logger.Error("shutdown error","error",err)}
}
