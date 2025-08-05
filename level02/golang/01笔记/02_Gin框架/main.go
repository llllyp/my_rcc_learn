package main

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"github.com/thinkerou/favicon"
	"log"
	"net/http"
)

// 自定义一个中间件(可以理解为 Java 中的拦截器)
func myHandler() gin.HandlerFunc {
	return func(context *gin.Context) {
		// 通过自定义的中间件, 设置的值, 在后续处理只要调用了这个中间件的都可以拿到这里的擦书
		context.Set("usersession", "userId-1")
		context.Next() // 放行

		//context.Abort()  //阻止
	}
}

func main() {

	// 创建服务
	ginServer := gin.Default()

	// 注册中间件
	ginServer.Use(myHandler())

	// 设置 icon
	ginServer.Use(favicon.New("./icon.jpg"))

	// 加载静态页面
	ginServer.LoadHTMLGlob("templates/*")

	// 加载资源文件
	ginServer.Static("/static", "./static")

	// 访问地址, 处理我们的请求 request  response
	ginServer.GET("/hello", func(context *gin.Context) {
		context.JSON(200, gin.H{"msg": "Hello World"})
	})

	// 响应一个页面给前端
	ginServer.GET("/index", func(context *gin.Context) {
		context.HTML(http.StatusOK, "index.html", gin.H{"msg": "这是 Go 后台 传递来的数据"})
	})

	// 传参方式一  url?userId=xxxx&userName=xxxx
	ginServer.GET("/user/info", myHandler(), func(context *gin.Context) {

		// 取出中间件的值
		userSession := context.MustGet("usersession").(string)
		log.Println("userSession: ", userSession)

		userId := context.Query("userId")
		userName := context.Query("userName")
		context.JSON(http.StatusOK, gin.H{
			"userId":   userId,
			"userName": userName,
		})
	})

	// 传参方式二  url/user/info/xxxx/xxxx
	ginServer.GET("/user/info/:userId/:userName", func(context *gin.Context) {
		userId := context.Param("userId")
		userName := context.Param("userName")
		context.JSON(http.StatusOK, gin.H{
			"userId":   userId,
			"userName": userName,
		})
	})

	// 前端给后端传递 json
	ginServer.POST("/json", func(context *gin.Context) {
		// request.body
		// []byte
		data, _ := context.GetRawData()

		var m map[string]interface{}
		// 包装为 json 数据 []byte
		_ = json.Unmarshal(data, &m)
		context.JSON(http.StatusOK, data)
	})

	// 表单处理
	ginServer.POST("/user/add", func(context *gin.Context) {
		username := context.PostForm("username")
		password := context.PostForm("password")

		context.JSON(http.StatusOK, gin.H{
			"msg":      "ok",
			"username": username,
			"password": password,
		})
	})

	// 路由
	ginServer.GET("/test", func(context *gin.Context) {
		// 301 重定向
		context.Redirect(http.StatusMovedPermanently, "http://www.baidu.com")
	})

	// 路由分组
	//userGroup := ginServer.Group("/user")
	//{
	//	userGroup.GET("/info", func(context *gin.Context) {
	//		// do something
	//	})
	//
	//	userGroup.POST("/add", func(context *gin.Context) {
	//		// do something
	//	})
	//}

	// 404
	ginServer.NoRoute(func(context *gin.Context) {
		context.JSON(http.StatusNotFound, nil)
	})

	// 服务器端口 host:port
	ginServer.Run(":1897")

}
