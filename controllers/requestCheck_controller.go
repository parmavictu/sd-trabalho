package controllers

import (
	"log"
	"net"
	"os"

	"github.com/gin-gonic/gin"
)

func CheckRequest(context *gin.Context) {
	id := context.Param("requestId")
	host := getHostName()
	ip := getIpv4(host)
	log.Print("Solicitação realizada com ", "Host: "+host, ", Ip: "+ip+", IdRequest: ", id)
	context.JSON(200, gin.H{
		"status": "Running",
	})
}

func getHostName() string {
	host, _ := os.Hostname()
	return host
}

func getIpv4(host string) string {
	addrs, _ := net.LookupIP(host)
	for _, addr := range addrs {
		if ipv4 := addr.To4(); ipv4 != nil {
			return ipv4.String()
		}
	}
	return ""
}
