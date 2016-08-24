//
//  Shell.swift
//  Sango
//
//  Created by Steve Hales on 8/24/16.
//  Copyright © 2016 Afero, Inc. All rights reserved.
//

import Foundation
import CoreFoundation

public class Shell
{
    private static var gitPath = "/usr/bin/git"
    
    private static func _shell(arguments: [String]) -> (output: String, status: Int32)
    {
        let task = NSTask()
        task.launchPath = "/bin/bash"
        var arg = ""
        for (index, value) in arguments.enumerate() {
            arg = arg.stringByAppendingString(value)
            if (index < (arguments.count - 1)) {
                arg = arg.stringByAppendingString(" && ")
            }
        }
        task.arguments = ["-c", arg]
        Utils.debug("$ \(arg)")
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        
        return (output: output, status: task.terminationStatus)
    }
    
    public static func gitInstalled() -> Bool
    {
        let output = _shell(["which git"])
        return (output.status == 0)
    }
    
    public static func gitInstalledPath() -> String {
        let output = _shell(["which git"])
        
        return output.output.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    public static func gitCheckoutAtTag(path: String, tag: String) -> Bool
    {
        let output = _shell(["cd \(path)",
            "\(gitPath) checkout tags/\(tag)"])
        Utils.debug(output.output)
        return (output.status == 0)
    }
    
    public static func gitDropChanges(path: String) -> Bool
    {
        let output = _shell(["cd \(path)",
            "\(gitPath) stash -u", "\(gitPath) stash drop"])
        return (output.status == 0)
    }
    
    public static func gitCurrentBranch(path: String) -> String
    {
        let output = _shell(["cd \(path)",
            "\(gitPath) rev-parse --abbrev-ref HEAD"])
        return output.output.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    public static func gitSetBranch(path: String, branch: String) -> Bool
    {
        gitDropChanges(path)
        let output = _shell(["cd \(path)",
            "\(gitPath) checkout \(branch)"])
        Utils.debug(output.output)
        return (output.status == 0)
    }
    
    public static func setup() -> Void
    {
        if gitInstalled() {
            gitPath = gitInstalledPath()
        }
    }
}