//
//  ViewController.swift
//  HelloWorld
//
//  Created by Aurelius Prochazka on 12/4/15.
//  Copyright © 2015 AudioKit. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {

    let audiokit = AKManager.sharedInstance
    let oscillator = AKOscillator()
    let bufferSize: UInt32 = 512

    @IBOutlet var plot: EZAudioPlot!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mixer = AKMixer(oscillator)
        audiokit.audioOutput = mixer
        audiokit.start()
        
        mixer.output?.installTapOnBus(0, bufferSize: bufferSize, format: nil) { [weak self] (buffer, time) -> Void in
            if let strongSelf = self {
                buffer.frameLength = strongSelf.bufferSize;
                let offset: Int = Int(buffer.frameCapacity - buffer.frameLength);
                let tail = buffer.floatChannelData[0];
                strongSelf.plot?.updateBuffer(&tail[offset],
                    withBufferSize: strongSelf.bufferSize);
            }
        }
    }
    
    @IBAction func toggleSound(sender: UIButton) {
        if oscillator.amplitude >  0.5 {
            oscillator.amplitude = 0
            sender.setTitle("Play Sine Wave at 440Hz", forState: .Normal)
        } else {
            oscillator.amplitude = 1
            sender.setTitle("Stop Sine Wave at 440Hz", forState: .Normal)
        }
        sender.setNeedsDisplay()
    }

}
