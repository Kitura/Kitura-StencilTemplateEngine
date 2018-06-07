/**
 * Copyright IBM Corporation 2015, 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import KituraTemplateEngine
import Stencil
import PathKit
import Foundation

/// An Error type for use when describing errors that can occur while working with
/// the `StencilTemplateEngine` type.
public enum StencilTemplateEngineError: Swift.Error {
    /// Thrown when the `StencilTemplateEngine.rootPaths` property is empty.
    case rootPathsEmpty
    
    /// A deprecated render method was called. Instead, call `render(filePath:context:options:templateName:)`.
    case deprecatedRenderMethodCalled
    
    /// Thrown when unable to cast 'json' value to a `[String: Any]`.
    case unableToCastJSONToDict
    
    /// Thrown when unable to encode the `Encodable` value provided to data.
    case unableToEncodeValue(value: Encodable)
    
    /// Thrown when Stencil fails to render the context with the given template.
    case unableToRenderContext(context: [String: Any])
    
    /// Thrown when a `[Encodable]` or `Set<Encodable>` is passed without a Key.
    case noKeyProvidedForType(value: Encodable)
}

/**
 A `TemplateEngine` for Kitura that uses [Stencil](https://github.com/stencilproject/Stencil) for templating.

 The default file extension for templates using this engine is `stencil`. If you do
 not explicitly provide a file extension in the call to `response.render` then this
 extension will be applied automatically.

 ### Usage Example: ###
 ```swift
    router.add(templateEngine: StencilTemplateEngine())

    // An example of using a dictionary of [String: Any] parameters to be rendered
    router.get("/hello") { request, response, next in
        try response.render("StencilExample.stencil", context: ["name": "World!"]])
        next()
    }
 ```
 A second example, using type-safe templating. For more information, see: https://developer.ibm.com/swift/2018/05/31/type-safe-templating/
 ```swift
    // A codable type containing structured data to be used in our template
    struct Friend: Codable {
        let firstName: String
        let lastName: String
    }

    // Structured data that we wish to render
    let friends = [Friend(firstName: "Jack", lastName: "Sparrow"), Friend(firstName: "Captain", lastName: "America")]

    // An example of using type-safe templating to render data from a Swift type
    router.get("/friends") { request, response, next in
        try response.render("MyStencil.stencil", with: friends, forKey: "friends")
        next()
    }
 ```
 */
public class StencilTemplateEngine: TemplateEngine {

    /// The file extension of files rendered by the KituraStencil template engine.
    public let fileExtension = "stencil"

    private let `extension`: Extension
    private var rootPaths: [Path] = []

    /// Initializes a KituraStencil template engine.
    ///
    /// - Parameter extension: An optional Stencil [`Extension`](http://stencil.fuller.li/en/latest/custom-template-tags-and-filters.html) for customizing the
    ///   underlying template engine.
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
    }

    /// Defines the filesystem paths where your Stencil templates can be located.
    /// Note that Kitura calls this function for you with a default path of `./Views/`
    /// or you can customize this by setting the `router.viewsPath` property.
    ///
    /// - Parameter rootPaths: The paths to be searched for Stencil templates.
    public func setRootPaths(rootPaths: [String]) {
        self.rootPaths = rootPaths.map { Path($0) }
    }

    /// This function is deprecated. Use `render(filePath:context:options:templateName:)` instead.
    public func render(filePath: String, context: [String: Any]) throws -> String {
        throw StencilTemplateEngineError.deprecatedRenderMethodCalled
    }

    /// Take a template file and a set of "variables" in the form of a context
    /// and generate content to be sent back to the client.
    /// Note that this function is called by Kitura when you call `response.render(resource:context:options:)`.
    ///
    /// - Parameter filePath: The path of the template file to use when generating
    ///                      the content.
    /// - Parameter context: A set of variables in the form of a Dictionary of
    ///                     Key/Value pairs, that can be used when generating the content.
    /// - Parameter options: Unused by this templating engine.
    /// - Parameter templateName: The name of the template.
    ///
    public func render(filePath: String, context: [String: Any], options: RenderingOptions,
                       templateName: String) throws -> String {
        if rootPaths.isEmpty {
            throw StencilTemplateEngineError.rootPathsEmpty
        }

        let loader = FileSystemLoader(paths: rootPaths)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        do {
            return try environment.renderTemplate(name: templateName,  context: context)
        } catch {
            throw StencilTemplateEngineError.unableToRenderContext(context: context)
        }
    }

    /// Take a template file and an Encodable type and generate the content to be sent back to the client.
    /// Note that this function is called by Kitura when you call `response.render(resource:with:forKey:options:)`.
    ///
    /// - Parameter filePath: The path of the template file to use when generating
    ///                      the content.
    /// - Parameter with: A value that conforms to Encodable which is used to generate the content.
    ///
    /// - Parameter forKey: A value used to match the Encodable values to the correct variable in a template file.
    ///                                 The `forKey` value should match the desired variable in the template file.
    /// - Parameter options: Unused by this templating engine.
    /// - Parameter templateName: The name of the template.
    ///
    public func render<T: Encodable>(filePath: String, with value: T, forKey key: String?,
                                   options: RenderingOptions, templateName: String) throws -> String {
        if rootPaths.isEmpty {
            throw StencilTemplateEngineError.rootPathsEmpty
        }
        
        //Throw an error if an array is passed without providing a key.
        if key == nil {
            let mirror = Mirror(reflecting: value)
            if mirror.displayStyle == .collection || mirror.displayStyle == .set {
                throw StencilTemplateEngineError.noKeyProvidedForType(value: value)
            }
        }
        
        let json: [String: Any]
        
        if let contextKey = key {
            json = [contextKey: value]
        } else {
            var data = Data()
            do {
                data = try JSONEncoder().encode(value)
            } catch {
                throw StencilTemplateEngineError.unableToEncodeValue(value: value)
            }
            
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw StencilTemplateEngineError.unableToCastJSONToDict
            }
            
            json = dict
        }
        
        return try render(filePath: filePath, context: json, options: options, templateName: templateName)
    }
}
