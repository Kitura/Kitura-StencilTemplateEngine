<p align="center">
<a href="http://kitura.io/">
<img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


<p align="center">
<a href="http://www.kitura.io/">
<img src="https://img.shields.io/badge/docs-kitura.io-1FBCE4.svg" alt="Docs">
</a>
<a href="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine">
<img src="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine.svg?branch=master" alt="Build Status - Master">
</a>
<img src="https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat" alt="Mac OS X">
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
<img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
<a href="http://swift-at-ibm-slack.mybluemix.net/">
<img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
</a>
</p>

# Kitura-StencilTemplateEngine
A templating engine for Kitura that uses Stencil-based templates.


## Summary
Kitura-StencilTemplateEngine is a plugin for [Kitura Template Engine](https://github.com/IBM-Swift/Kitura-TemplateEngine.git) for using [Stencil](https://github.com/kylef/Stencil) with the [Kitura](https://github.com/IBM-Swift/Kitura) server framework. This makes it easy to use Stencil templating, with a Kitura server, to create an HTML page with integrated Swift variables.

## Stencil Template File
The template file is basically HTML with gaps where we can insert code and variables. [Stencil](https://github.com/kylef/Stencil) is a templating language used to write a template file and Kitura-StencilTemplateEngine can use any standard Stencil template.

The [Stencil user guide](https://stencil.fuller.li/en/latest/) provides documentation and examples on how to write a Stencil template File.

The Kitura router, by default, will look in the `Views` folder for Stencil template files, that is files with the extension `.stencil`.


## Example
The following example takes a server generated using `kitura init` and modifies it to serve Stencil-formatted text from a `.stencil` file.

The files which will be edited in this example, are structured as follows:

<pre>
&lt;ServerRepositoryName&gt;
├── Package.swift
├── Sources
│    └── Application
│         └── Application.swift
└── Views
     └── Example.stencil
</pre>

The `Views` folder and `Example.stencil` file will be created later on in this example, since they are not initialized by `kitura init`.

#### Package.swift
* Define ["https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git"](https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git) as a dependency.
* Add "KituraStencil" to the targets for Application.

#### Application.swift
Inside the `Application.swift` file, add the following code to render the `Example.stencil` template file on the "/articles" route.

```swift
import KituraStencil
```

Add the following code inside the `postInit()` function:

```swift
router.add(templateEngine: StencilTemplateEngine())
router.get("/articles") { _, response, next in
var context: [String: [[String:Any]]] =
    [
        "articles": [
            ["title" : "Using Stencil with Swift", "author" : "IBM Swift"],
            ["title" : "Server-Side Swift with Kitura", "author" : "Kitura"],
        ]
    ]
    try response.render("Example.stencil", context: context)
    response.status(.OK)
    next()
}
```

#### Example.stencil
Create the `Views` folder and put the following Stencil template code into a file called `Example.stencil`:

```
<html>
    There are {{ articles.count }} articles. <br />

    {% for article in articles %}
        - {{ article.title }} written by {{ article.author }}. <br />
    {% endfor %}
</html>
```
This example is adapted from the [Stencil user guide](https://stencil.fuller.li/en/latest/) code. It will display the number of articles followed by a list of the articles and their authors.

Run the application and once the server is running, go to [http://localhost:8080/articles](http://localhost:8080/articles) to view the rendered Stencil template.

## License
This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/IBM-Swift/Kitura-StencilTemplateEngine/blob/master/LICENSE.txt).
