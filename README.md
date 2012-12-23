# Theoricus #

Theoricus is a MVC implementation for CoffeeScript targeting Single Page Applications, made to serve your needs and make you happy.

There's simple naming conventions (as you see in rails and many others), with a powerful build system behind it. There's also a naviagation mechanism built to let your free to code your shit instead of handling url's manually.

It uses some (loved'n'hated) pre-processed langs to accomplish the goals.

 - [Stylus](https://github.com/learnboost/stylus) (css)
 - [Jade](https://github.com/visionmedia/jade) (html)
 - [CoffeeScript](https://github.com/jashkenas/coffee-script) (js)

It's in a very alpha version, use at your own risk.

Have fun. :)

# Installation

````bash
npm install -g theoricus
````

# Help

````bash
Usage:
  theoricus new      path
  theoricus add      model|view|controller|mvc 
  theoricus rm       model|view|controller|mvc 
  theoricus start    
  theoricus compile  
  theoricus index    

Options:
             new   Creates a new working project in the file system.
             add   Generates a new model|view|controller file.
              rm   Destroy some model|view|controller file.
           start   Starts app in watch'n'compile mode at http://localhost:11235
         compile   Compile app to release destination.
           index   Index the whole application to a static non-js version.
         version   Show theoricus version.
            help   Show this help screen.
````

# Getting started

To scaffold a new working project:

````bash
theoricus new myawesomeapp
````

It'll produce the following structure:

````bash
myawesomeapp
|-- app
|   |-- app_controller.coffee
|   |-- app_model.coffee
|   |-- app_view.coffee
|   |-- controllers
|   |   `-- mains.coffee
|   |-- models
|   |   `-- main.coffee
|   |-- static
|   |   |-- _mixins
|   |   |   |-- jade
|   |   |   `-- stylus
|   |   |       `-- global_mixins.styl
|   |   `-- main
|   |       |-- index.jade
|   |       `-- index.styl
|   `-- views
|       `-- main
|           `-- index.coffee
|-- config
|   |-- app.coffee
|   `-- routes.coffee
`-- public
		|-- app.css
		|-- app.js
		`-- index.html
````

# Starting up

````bash
cd myawesomeapp
theoricus start
````

Visit the url [http://localhost:11235](http://localhost:11235) and you should see a success status.

# Demo Application

There's a basic demo application here: <BR>
https://github.com/serpentem/theoricus-demo-app

# Sites Made with Theoricus

## Codeman
> http://www.codeman.co/
* Source: https://github.com/giuliandrimba/codeman
* Credits: [Giulian Drimba](https://github.com/giuliandrimba)

# Changelog
----

> [CHANGELOG.md](https://github.com/serpentem/theoricus/tree/master/build/CHANGELOG.md)
