//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver

import SystemModule
import UserModule
import ApiModule
import AdminModule
import FrontendModule

import FileModule
import RedirectModule
import BlogModule
import AnalyticsModule
import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule

/// setup metadata delegate object
Feather.metadataDelegate = FrontendMetadataDelegate()

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let feather = try Feather(env: env)
defer { feather.stop() }

try feather.configure(database: .sqlite(.file("db.sqlite")),
                      databaseId: .sqlite,
                      fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public, workDirectory: "assets"),
                      fileStorageId: .local,
                      modules: [
                        SystemBuilder(),
                        UserBuilder(),
                        ApiBuilder(),
                        AdminBuilder(),
                        FrontendBuilder(),

                        FileBuilder(),
                        RedirectBuilder(),
                        BlogBuilder(),
                        AnalyticsBuilder(),
                        AggregatorBuilder(),
                        SponsorBuilder(),
                        SwiftyBuilder(),
                        MarkdownBuilder(),
                      ])

if feather.app.isDebug {
    try feather.reset(resourcesOnly: true)
}
try feather.start()
