package controller

import "github.com/gin-gonic/gin"



// getApk get the apk of the mobile godoc
// @Tags download
// @Summary APK oh the mobile application
// @Description Return the APK to download by the mobile
// @Router /download/apk [get]
func getApk(c *gin.Context) {
	c.FileAttachment("/usr/apk/cash-manager.apk", "cash-manager.apk")
}

func AddRouteDocument(rg *gin.RouterGroup) {
	doc := rg.Group("/download")

	doc.GET("/apk", getApk)
}
