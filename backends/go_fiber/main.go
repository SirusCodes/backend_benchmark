package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{"response": "Hello, World!"})
	})

	app.Post("/echo", func(c *fiber.Ctx) error {
		type User struct {
			Name string `json:"name"`
		}

		user := new(User)
		if err := c.BodyParser(user); err != nil {
			return err
		}
		return c.JSON(fiber.Map{"response": "Hello, " + user.Name + "!"})
	})

	app.Post("/json_obj", func(c *fiber.Ctx) error {
		type Post struct {
			UserId int    `json:"userId"`
			Id     int    `json:"id"`
			Title  string `json:"title"`
			Body   string `json:"body"`
		}

		posts := new([]Post)
		if err := c.BodyParser(&posts); err != nil {
			return err
		}
		return c.SendString(fmt.Sprint(len(*posts)))
	})

	app.Post("/file_upload", func(c *fiber.Ctx) error {
		file, err := c.FormFile("benchmark")
		if err != nil {
			return err
		}
		return c.SendString(fmt.Sprint(file.Size))
	})

	app.Listen(":8080")
}
