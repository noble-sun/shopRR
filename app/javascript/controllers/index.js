// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import ProductController from "./product_controller"
application.register("product", ProductController)

import ReviewController from "./review_controller"
application.register("review", ReviewController)
