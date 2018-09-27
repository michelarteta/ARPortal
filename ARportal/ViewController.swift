//
//  ViewController.swift
//  ARPortal
//
//  Created by parth on 8/25/17.
//  Copyright © 2017 parthanand.com. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // setting plane detection to horizontal so that we are able to detect horizontal planes.
        configuration.planeDetection = .horizontal


        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // called when touches are detected on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            // gives us the location of where we touched on the 2D screen.
            let touchLocation = touch.location(in: sceneView)
            
            // hitTest is performed to get the 3D coordinates corresponding to the 2D coordinates that we got from touching the screen.
            // That 3d coordinate will only be considered when it is on the existing plane that we detected.
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // if we have got some results using the hitTest then do this
            if let hitResult = results.first {
                

                let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                
                if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
                    
                    
                    boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.05, z: hitResult.worldTransform.columns.3.z)
                    
                    // finally the box is added to the scene.
                    sceneView.scene.rootNode.addChildNode(boxNode)
                    
                }
                
                
            }
            
        }
    }
    
    
    // this is a delegate method which comes from ARSCNViewDelegate, and this method is called when a horizontal plane is detected.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            // anchors can be of many types, as we are just dealing with horizontal plane detection we need to downcast anchor to ARPlaneAnchor
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // creating a plane geometry with the help of dimentions we got using plane anchor.
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // a node is basically a position.
            let planeNode = SCNNode()
            
            // setting the position of the plane geometry to the position we got using plane anchor.
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            // when a plane is created its created in xy plane instead of xz plane, so we need to rotate it along x axis.
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            //create a material object
            let gridMaterial = SCNMaterial()
            
            //setting the material as an image. A material can also be set to a color.
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // assigning the material to the plane
            plane.materials = [gridMaterial]
            
            
            // assigning the position to the plane
            planeNode.geometry = plane
            
            //adding the plane node in our scene
            node.addChildNode(planeNode)
            
            
            
        }
        
        else {
            
            return
        }
        
    }
    
}
