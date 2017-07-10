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

import KituraTemplateEngine
import Stencil
import PathKit

public enum StencilTemplateEngineError: Swift.Error {
    case rootPathsEmpty
    case deprecatedRenderMethodCalled // call render(filePath, context, options, templateName)
}

public class StencilTemplateEngine: TemplateEngine {
    public let fileExtension = "stencil"
    private let `extension`: Extension
    private var rootPaths: [Path] = []

    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
    }

    public func setRootPaths(rootPaths: [String]) {
        self.rootPaths = rootPaths.map { Path($0) }
    }

    public func render(filePath: String, context: [String: Any]) throws -> String {
        throw StencilTemplateEngineError.deprecatedRenderMethodCalled
    }

    public func render(filePath: String, context: [String: Any], options: RenderingOptions,
                       templateName: String) throws -> String {
        if rootPaths.isEmpty {
            throw StencilTemplateEngineError.rootPathsEmpty
        }

        let loader = FileSystemLoader(paths: rootPaths)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        return try environment.renderTemplate(name: templateName,  context: context)
    }
}
