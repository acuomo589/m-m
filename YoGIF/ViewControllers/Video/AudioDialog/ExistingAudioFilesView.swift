import UIKit
import FDWaveformView
import AVFoundation
//import AudioKit

class ExistingAudioFilesView: UIView, UITableViewDelegate, UITableViewDataSource {
    // TODO: filter unexisting String? and URL? before adding them - will simplify code
    var files: [String?]?
    var localFiles: [URL?]?
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    let reuseId = "reuseIdExistingFiles"
    let reuseIdSimple = "reuseIdExistingFilesSimple"
    weak var delegate: AudioDialogView?

    func setup(sv: UIView, delegate: AudioDialogView, type: Int) {
        sv.addSubview(self)
        self.delegate = delegate
//        self.backgroundColor = .red

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.backgroundColor = UIColor.white
        tableView.register(ExistingAudioTableViewCell.self, forCellReuseIdentifier: self.reuseId)
        tableView.register(ExistingAudioSimpleTableViewCell.self, forCellReuseIdentifier: self.reuseIdSimple)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let files = files {
            return files.count
        } else if let localFiles = localFiles {
            return localFiles.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let files = files {
            let file = files[indexPath.row]

            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId, for: indexPath as IndexPath) as! ExistingAudioTableViewCell


            //            cell.graph.audioURL = //file
            cell.title.text = file//file.path
            //            cell.duration.text = "0:01"
            return cell
        } else if let localFiles = localFiles {

            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdSimple,
                                                     for: indexPath as IndexPath) as! ExistingAudioSimpleTableViewCell

            //            cell.graph.audioURL = //file
            if let file = localFiles[indexPath.row] {
                cell.title.text = file.lastPathComponent.components(separatedBy: ".")[0]
                cell.url = file
            }
            return cell

            //            cell.duration.text = "0:01"

        } else {
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // sync audio with video
        // dpwnload audio
        // save it
        // open Media
        if let files = files, let _ = files[indexPath.row] {

        } else if let localFiles = localFiles, let file = localFiles[indexPath.row] {
            if let delegate = self.delegate {
                delegate.onStopRecording(url: file)
                delegate.saveRecord()
            }
        }



    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.files != nil {
            return 70
        } else {
            return 52
        }

    }
}

class ExistingAudioTableViewCell: UITableViewCell {
    let title = UILabel()
    let duration = UILabel()
    var graph = FDWaveformView()
    var icon = UIImageView(image: #imageLiteral(resourceName: "cellArrowGreen"))

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -60).isActive = true
        title.text = "Title"
        title.font = UIFont(name: "Helvetica", size: 14)
        title.textColor = .lightGray

        self.contentView.addSubview(duration)
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        duration.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        duration.text = "00:00"
        duration.font = UIFont(name: "Helvetica", size: 14)
        duration.textColor = .lightGray

        self.contentView.addSubview(graph)
        graph.translatesAutoresizingMaskIntoConstraints = false
        graph.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        graph.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        graph.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40).isActive = true
        graph.heightAnchor.constraint(equalToConstant: 30).isActive = true
        graph.backgroundColor = .white
        graph.progressColor = AppConstants.colorGreen
        graph.wavesColor = AppConstants.colorGreen

        self.contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: graph.centerYAnchor, constant: 0).isActive = true
        icon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.contentMode = .scaleAspectFit
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

class ExistingAudioSimpleTableViewCell: UITableViewCell {
    let soundButton = UIButton()
    let title = UILabel()
    var icon = UIImageView(image: #imageLiteral(resourceName: "cellArrowGreen"))
    var url: URL?
    var player: AVAudioPlayer?

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(soundButton)
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        soundButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        soundButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        soundButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        soundButton.contentMode = .scaleAspectFit
        soundButton.setBackgroundImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        soundButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)

        self.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: soundButton.rightAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -60).isActive = true
        title.text = "Title"
        title.font = UIFont(name: "Helvetica", size: 14)
        title.textColor = .lightGray

        self.contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        icon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.contentMode = .scaleAspectFit
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    @objc func playSound() {
        if let url = url {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }

                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
}
