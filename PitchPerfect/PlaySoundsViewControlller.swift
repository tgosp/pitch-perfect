//
//  PlaySoundsViewControlller.swift
//  PitchPerfect
//
//  Created by Todor Gospodinov on 12/13/15.
//  Copyright © 2015 Todor Gospodinov. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewControlller: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: create audio player
        audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioPlayer.delegate = self
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)
    }

    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopAudioPlaying()
    }
    
    func stopAudioPlaying(){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudioPlaying()
        
        // MARK: play audio slow
        stopButton.hidden = false
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func playFastAUdio(sender: AnyObject) {
        // MARK: task 2
        stopAudioPlaying()
        
        // MARK: play audio fast
        stopButton.hidden = false
        audioPlayer.rate = 2
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudioPlaying()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()

    }
    
    
    @IBAction func stopPlayAudio(sender: UIButton) {
        // MARK: stop play audio
        stopAudioPlaying()
        stopButton.hidden = true
    }
    

}

