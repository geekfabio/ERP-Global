package config

import "os"

type Config struct { Address string }

func FromEnv() Config {
 address := os.Getenv("API_ADDRESS")
 if address == "" { address = ":8080" }
 return Config{Address: address}
}
