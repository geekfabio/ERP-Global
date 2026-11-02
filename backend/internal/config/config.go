package config

import "os"

type Config struct {
 Address string
 DatabaseURL string
}

func FromEnv() Config {
 addr := os.Getenv("API_ADDRESS")
 if addr == "" { addr = ":8080" }
 return Config{Address:addr, DatabaseURL:os.Getenv("DATABASE_URL")}
}
