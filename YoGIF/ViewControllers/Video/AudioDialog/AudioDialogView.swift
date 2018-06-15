import UIKit
import FDWaveformView
import AVFoundation
//import AudioKit

class AudioDialogView: UIView, YoSegmentControlControlDelegate {
    
    weak var delegate: VideoViewController?
    let topBar = UIView()
    let browseContainer = ExistingAudioFilesView()
    let recordContainer = AudioRecordView()
    let finishedRecordContainer = FinishedRecordView()
    let mySoundsCountainer = ExistingAudioFilesView()

    var currentUrl: URL?

    func add(to superView: UIView, anchorTo: UIButton,
             delegate: VideoViewController, files: [String?]?, localFiles: [URL?]?) {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.delegate = delegate
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: anchorTo.topAnchor, constant: -4).isActive = true
        self.heightAnchor.constraint(equalToConstant: 260).isActive = true
        self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -20).isActive = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
//        self.layer.borderWidth = 10
        self.backgroundColor = .clear
        let holderView = UIView()
        holderView.backgroundColor = .white
        holderView.layer.cornerRadius = 7
        self.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        holderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        holderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        holderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
//        holderView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        
        self.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topBar.backgroundColor = .red

        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 16).isActive = true
        closeButton.rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        closeButton.setImage(#imageLiteral(resourceName: "weeklyClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.contentMode = .scaleAspectFit
        
        let segmentControl = YoSegmentControl()
        topBar.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 3).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 0).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 50).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -50).isActive = true
        segmentControl.segmentControl.insertSegment(withTitle: "RECORD", at: 0, animated: false)
        segmentControl.segmentControl.insertSegment(withTitle: "BROWSE", at: 1, animated: false)
        segmentControl.segmentControl.selectedSegmentIndex = 0
        segmentControl.changeSelection(animated: false)
        segmentControl.redraw(animated: false)
        segmentControl.delegate = self
        segmentControl.segmentControl.tintColor = .white

        setupRecord()
        setupFinishedRecord()
        setupBrowse()

        if let files = files {
            browseContainer.files = files
            mySoundsCountainer.files = files
        } else if let localFiles = localFiles {
            browseContainer.localFiles = localFiles
            mySoundsCountainer.localFiles = localFiles
        }
        browseContainer.tableView.reloadData()
        mySoundsCountainer.tableView.reloadData()


        recordContainer.isHidden = false
        browseContainer.isHidden = true
        mySoundsCountainer.isHidden = true
        finishedRecordContainer.isHidden = true
    }

    func selectedItem(index: Int) {
        if index == 0 {
            recordContainer.isHidden = false
            browseContainer.isHidden = true
            mySoundsCountainer.isHidden = true
            finishedRecordContainer.isHidden = true
            topBar.backgroundColor = .red

        } else if index == 1 {
            topBar.backgroundColor = AppConstants.colorGreen

            recordContainer.isHidden = true
            browseContainer.isHidden = false
            mySoundsCountainer.isHidden = true
            finishedRecordContainer.isHidden = true
        }
    }

    func setupFinishedRecord() {
        finishedRecordContainer.setup(sv: self, delegate: self)
        self.addSubview(finishedRecordContainer)
        finishedRecordContainer.translatesAutoresizingMaskIntoConstraints = false
        finishedRecordContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        finishedRecordContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        finishedRecordContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        finishedRecordContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        finishedRecordContainer.isHidden = true
    }

    func setupRecord() {
        recordContainer.setup(sv: self, delegate: self)
        self.addSubview(recordContainer)
        recordContainer.translatesAutoresizingMaskIntoConstraints = false
        recordContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        recordContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        recordContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recordContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        recordContainer.isHidden = true
    }

    func setupBrowse() {
        browseContainer.setup(sv: self, delegate: self, type: 0)
        self.addSubview(browseContainer)
        browseContainer.translatesAutoresizingMaskIntoConstraints = false
        browseContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        browseContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        browseContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        browseContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        browseContainer.isHidden = true
    }


    func saveRecord() {
        if let delegate = self.delegate, let url = self.currentUrl {
            // copy file into documents folder
            // save link into user's files array
            delegate.onSaveRecord(url: url)
        }

    }

    func discardRecord() {
        self.recordContainer.isHidden = false
        self.finishedRecordContainer.isHidden = true
        recordContainer.removeCurrentAudio()
//        if let waveView = recordContainer.waveView {
//            waveView.clear()
//        }
    }

    func onStopRecording(url: URL) {
        recordContainer.isHidden = true
        finishedRecordContainer.isHidden = false
        finishedRecordContainer.finishedWaveView.audioURL = url
        self.currentUrl = url
        finishedRecordContainer.playCurrentAudio()
    }

    @objc func close() {
        delegate?.audioTapped()
    }
}
