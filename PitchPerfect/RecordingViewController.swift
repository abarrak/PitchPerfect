//
//  RecordingViewController.swift
//  PitchPerfect
//
//  Created by Abdullah on 9/24/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("Button was pressed.")
        configureUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                          .UserDomainMask, true)[0] as String
        let recordingName = "recorderVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("Recording is stopped.")
        configureUI(recording: false)
        
        audioRecorder.stop()

        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View appeared ...")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Showing ..")
        if flag {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            let alert = UIAlertController(title: "Error", message: "Saving of recording failed.",
                preferredStyle: UIAlertControllerStyle.Alert)
            showViewController(alert, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    private func configureUI(recording recording: Bool) {
        recordingLabel.text = recording ? "Recording in progress .." : "Tab to record"
        stopRecordingButton.enabled = recording
        recordButton.enabled = !recording
    }
    
}

