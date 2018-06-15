import UIKit
import FDWaveformView
import AVFoundation
//import AudioKit
//import AudioKitUI
import OCWaveView
import SwiftSiriWaveformView

class AudioRecordView: UIView, AVAudioRecorderDelegate {
    weak var delegate: AudioDialogView?
    let recordLabel = UILabel()
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?
    var animtaionTimer: Timer?
    var currentUrl: URL?
    let waveView = SwiftSiriWaveformView()
    var value = 0.01
    //    let mic = AKMicrophone()
    //    var audioInputPlot: AKNodeOutputPlot?
    //    var tracker: AKFrequencyTracker!
    //    var silence: AKBooster!

    func setup(sv: UIView, delegate: AudioDialogView) {
        self.delegate = delegate
        
        let recordButton = UIButton()
        let buttonSize = CGFloat(60)
        self.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        recordButton.backgroundColor = .red
        recordButton.layer.cornerRadius = buttonSize * 0.5
        recordButton.addTarget(self, action: #selector(startRecord), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
        recordButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)

        let bottomSeparator = UIView()
        self.addSubview(bottomSeparator)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -30).isActive = true
        bottomSeparator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        bottomSeparator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        bottomSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomSeparator.backgroundColor = .lightGray

        self.addSubview(recordLabel)
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor, constant: -10).isActive = true
        recordLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        recordLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        recordLabel.textAlignment = .center
        recordLabel.font = UIFont(name: "Helvetica", size: 14)
        recordLabel.textColor = .lightGray
        recordLabel.text = "Tap and hold to record"

        let topSeparator = UIView()
        self.addSubview(topSeparator)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.bottomAnchor.constraint(equalTo: recordLabel.topAnchor, constant: -10).isActive = true
        topSeparator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        topSeparator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topSeparator.backgroundColor = .lightGray

        let waveContainer = UIView()
        self.addSubview(waveContainer)
        waveContainer.translatesAutoresizingMaskIntoConstraints = false
        waveContainer.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -10).isActive = true
        waveContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        waveContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        waveContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        waveContainer.clipsToBounds = true

        //        AKSettings.audioInputEnabled = true
        //        tracker = AKFrequencyTracker.init(mic, hopSize: 200, peakCount: 2000)
        //        silence = AKBooster(tracker, gain: 0)
        //
        //        let localWaveView = AKNodeOutputPlot(mic, frame: waveContainer.bounds)
        //        waveContainer.addSubview(localWaveView)
        //        localWaveView.translatesAutoresizingMaskIntoConstraints = false
        //        localWaveView.leftAnchor.constraint(equalTo: waveContainer.leftAnchor, constant: 0).isActive = true
        //        localWaveView.rightAnchor.constraint(equalTo: waveContainer.rightAnchor, constant: 0).isActive = true
        //        localWaveView.topAnchor.constraint(equalTo: waveContainer.topAnchor, constant: -360).isActive = true
        //        localWaveView.bottomAnchor.constraint(equalTo: waveContainer.bottomAnchor, constant: 360).isActive = true
        //        localWaveView.plotType = .rolling
        //        localWaveView.shouldFill = true
        //        localWaveView.shouldMirror = true
        //        localWaveView.backgroundColor = .white
        //        localWaveView.color = .red
        //        self.audioInputPlot = localWaveView

        waveContainer.addSubview(waveView)
        waveView.translatesAutoresizingMaskIntoConstraints = false
        waveView.leftAnchor.constraint(equalTo: waveContainer.leftAnchor, constant: 0).isActive = true
        waveView.rightAnchor.constraint(equalTo: waveContainer.rightAnchor, constant: 0).isActive = true
        waveView.topAnchor.constraint(equalTo: waveContainer.topAnchor, constant: 0).isActive = true
        waveView.bottomAnchor.constraint(equalTo: waveContainer.bottomAnchor, constant: 0).isActive = true
        waveView.backgroundColor = .white
        waveView.numberOfWaves = 5
        waveView.waveColor = .red
        waveView.primaryLineWidth = 3
        waveView.secondaryLineWidth = 1
        waveView.density = 0.3
        waveView.amplitude = 0
    }

    func removeCurrentAudio() {
        if let url = self.currentUrl {
            // remove old file
            do {
                let fileManager = FileManager.default
                var isDir: ObjCBool = false
                if fileManager.fileExists(atPath: url.path, isDirectory:&isDir) {
                    try fileManager.removeItem(at: url)
                }
                self.currentUrl = nil
            }
            catch {
                print("removeAudio error: \(error.localizedDescription)")
            }
        }
        //        AKAudioFile.cleanTempDirectory()
        //        if let audioInputPlot = self.audioInputPlot {
        //            audioInputPlot.clear()
        //        }
    }

    @objc func startRecord() {

        self.recordLabel.text = "0:00"
        removeCurrentAudio()

        //        AudioKit.output = silence
        //        do {
        //            AudioKit.start()
        //        } catch (_) {
        //            print("error")
        //        }

        do {
            let baseString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                 FileManager.SearchPathDomainMask.userDomainMask, true).first!
            let pathComponents = [baseString, /*UUID().uuidString*/"temp_audio" + ".m4a"]
            let audioURL = NSURL.fileURL(withPathComponents: pathComponents)

            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try session.setActive(true)

            var recordSettings = [String : AnyObject]()
            recordSettings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            recordSettings[AVSampleRateKey] = 44100.0 as AnyObject
            recordSettings[AVNumberOfChannelsKey] = 2 as AnyObject

            if let url = audioURL {
                let recorder = try AVAudioRecorder(url: url, settings: recordSettings)
                recorder.isMeteringEnabled = true
                recorder.record()
                self.audioRecorder = recorder
                self.currentUrl = url

                self.timer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(updateRecordTime),
                                                  userInfo: nil,
                                                  repeats: true)
                self.animtaionTimer = Timer.scheduledTimer(timeInterval: 0.02,
                                                  target: self,
                                                  selector: #selector(updateAnimation),
                                                  userInfo: nil,
                                                  repeats: true)
            }
        } catch (_) {
        }
    }

    @objc func updateAnimation() {
        if waveView.amplitude > 0.9 {
            value = -0.01
        } else if waveView.amplitude < 0.3  {
            value = 0.01
        }
        waveView.amplitude += CGFloat(value)


    }

    @objc func updateRecordTime() {
        if let recorder = self.audioRecorder {

            let interval = recorder.currentTime
            let totalSeconds: Double = interval
            let minutes = Int(floor(totalSeconds / 60))
            let seconds = Int(round(totalSeconds.truncatingRemainder(dividingBy:60)))
            let timeString = String(format: "%02d:%02d", minutes, seconds)

//            let waveValue = CGFloat(seconds)
//            print(waveValue)
//            waveView.amplitude += waveValue
//            self.audioView.amplitude += self.change

            recordLabel.text = timeString
        }
    }

    @objc func stopRecord() {
        if let timer = self.timer {
            timer.invalidate()
        }
        if let animtaionTimer = self.animtaionTimer {
            animtaionTimer.invalidate()
        }
        waveView.amplitude = 0
        recordLabel.text = "Tap and hold to record"
        if let recorder = self.audioRecorder, let url = self.currentUrl {
            recorder.stop()
            if let delegate = delegate {
                delegate.onStopRecording(url: url)
            }

        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecord()
        }
    }
}
