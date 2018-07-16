<p align="center">
<a href="http://kitura.io/">
<img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


<p align="center">
    <a href="https://ibm-swift.github.io/Kitura-StencilTemplateEngine/index.html">
    <img src="https://img.shields.io/badge/apidoc-KituraStencilTemplateEngine-1FBCE4.svg?style=flat" alt="APIDoc">
    </a>
    <a href="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine">
    <img src="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine.svg?branch=master" alt="Build Status - Master">
    </a>
    <img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
    <img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
    <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
    <a href="http://swift-at-ibm-slack.mybluemix.net/">
    <img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
    </a>
</p>

# Kitura-StencilTemplateEngine

Kitura-StencilTemplateEngine is a plugin for [Kitura Template Engine](https://github.com/IBM-Swift/Kitura-TemplateEngine.git) for using [Stencil](https://github.com/kylef/Stencil) with the [Kitura](https://github.com/IBM-Swift/Kitura) server framework. This makes it easy to use Stencil templating, with a Kitura server, to create an HTML page with integrated Swift variables.

## Swift version
The latest version of Kitura-StencilTemplateEngine requires **Swift 4.0** or newer. You can download this version of the Swift binaries by following this [link](https://swift.org/download/). Compatibility with other Swift versions is not guaranteed.

## Stencil Template File
The template file is basically HTML with gaps where we can insert code and variables. [Stencil](https://github.com/kylef/Stencil) is a templating language used to write a template file and Kitura-StencilTemplateEngine can use any standard Stencil template.

The [Stencil user guide](https://stencil.fuller.li/en/latest/) provides documentation and examples on how to write a Stencil template file.

The Kitura router, by default, will look in the `Views` folder for Stencil template files, that is files with the extension `.stencil`.

## Usage

#### Add dependencies

Add the `Kitura-StencilTemplateEngine` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `Kitura-StencilTemplateEngine` [release](https://github.com/IBM-Swift/Kitura-StencilTemplateEngine/releases).

```swift
.package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "x.x.x")
```

Add `KituraStencil` to your target's dependencies:

```swift
.target(name: "example", dependencies: ["KituraStencil"]),
```

#### Import package

```swift
import KituraStencil
```

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

#### Dependencies

Add the dependencies to your Package.swift file (as defined in [Add dependencies](#add_dependencies) above).

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

## API Documentation
For more information visit our [API reference](https://ibm-swift.github.io/Kitura-StencilTemplateEngine/index.html).

## Community

We love to talk server-side Swift, and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License
This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/IBM-Swift/Kitura-StencilTemplateEngine/blob/master/LICENSE.txt).
