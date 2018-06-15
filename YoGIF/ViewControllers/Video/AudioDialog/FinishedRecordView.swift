import UIKit
import FDWaveformView
import AVFoundation
//import AudioKit

class FinishedRecordView: UIView, FDWaveformViewDelegate {
    let recordLabel = UILabel()
    let finishedWaveView = FDWaveformView()
    var audioPlayer: AVAudioPlayer?
    var currentUrl: URL?
    let loadingIndicator = UIActivityIndicatorView()
    weak var delegate: AudioDialogView?

    func setup(sv: UIView, delegate: AudioDialogView) {
        sv.addSubview(self)
        self.delegate = delegate

        let saveButton = UIButton()
        let buttonSize = CGFloat(60)
        self.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        saveButton.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 16).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        saveButton.backgroundColor = .white
        saveButton.setImage(#imageLiteral(resourceName: "recordSave"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveRecord), for: .touchUpInside)

        let cancelButton = UIButton()

        self.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -16).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cancelButton.backgroundColor = .white
        cancelButton.setImage(#imageLiteral(resourceName: "recordCancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(discardRecord), for: .touchUpInside)

        let bottomSeparator = UIView()
        self.addSubview(bottomSeparator)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -30).isActive = true
        bottomSeparator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        bottomSeparator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        bottomSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomSeparator.backgroundColor = .lightGray


        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = .lightGray
        label.text = "Sounds good?"

        let topSeparator = UIView()
        self.addSubview(topSeparator)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
        topSeparator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        topSeparator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topSeparator.backgroundColor = .lightGray

        self.addSubview(finishedWaveView)
        finishedWaveView.translatesAutoresizingMaskIntoConstraints = false
        finishedWaveView.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -10).isActive = true
        finishedWaveView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        finishedWaveView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        finishedWaveView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        finishedWaveView.backgroundColor = .white
        finishedWaveView.progressColor = .lightGray//.red
        finishedWaveView.wavesColor = .lightGray
        finishedWaveView.delegate = self

        let onWaveTap = UITapGestureRecognizer()
        onWaveTap.addTarget(self, action: #selector(onWaveTap(_:)))
        finishedWaveView.addGestureRecognizer(onWaveTap)

        self.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: finishedWaveView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: finishedWaveView.centerYAnchor).isActive = true
        loadingIndicator.tintColor = .black
        loadingIndicator.color = .black
    }

    @objc func discardRecord() {
        if let delegate = delegate {
            delegate.discardRecord()
        }
    }

    @objc func onWaveTap(_ gesture: UITapGestureRecognizer) {
//        let rangeSamples = CGFloat(finishedWaveView.zoomSamples.count)
//        finishedWaveView.highlightedSamples = 0 ..< Int((CGFloat(finishedWaveView.zoomSamples.startIndex) + rangeSamples * gesture.location(in: finishedWaveView).x / finishedWaveView.bounds.width))
        playCurrentAudio()

    }

    func playCurrentAudio() {
        if let url = delegate?.currentUrl {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()

                player.play()
                self.audioPlayer = player

            } catch let error as NSError {
                print(error)
            }
        }
    }

    func waveformViewWillRender(_ waveformView: FDWaveformView) {
        loadingIndicator.startAnimating()
    }

    func waveformViewDidRender(_ waveformView: FDWaveformView) {
        playCurrentAudio()
        loadingIndicator.stopAnimating()
    }

    @objc func saveRecord() {
        if let delegate = self.delegate {
            delegate.saveRecord()
        }
    }
}
