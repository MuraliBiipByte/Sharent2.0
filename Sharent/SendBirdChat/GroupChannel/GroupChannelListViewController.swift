//
//  GroupChannelListViewController.swift
//  SendBird-iOS
//
//  Created by Jed Kyung on 10/10/16.
//  Copyright © 2016 SendBird. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SendBirdSDK

class GroupChannelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate, CreateGroupChannelUserListViewControllerDelegate, ConnectionManagerDelegate, SBDChannelDelegate, SBDConnectionDelegate {
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noChannelLabel: UILabel!
    
//    private var refreshControl: UIRefreshControl?
    private var channels: [SBDGroupChannel] = []
    private var editableChannel: Bool = false
    private var groupChannelListQuery: SBDGroupChannelListQuery?
    private var typingAnimationChannelList: [String] = []
    
    private var cachedChannels: Bool = true
    
    private var firstLoading: Bool = false
     var userId :String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          print(self.channels)
//        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isEditing = false
        self.tableView.register(GroupChannelListTableViewCell.nib(), forCellReuseIdentifier: GroupChannelListTableViewCell.cellReuseIdentifier())
        self.tableView.register(GroupChannelListEditableTableViewCell.nib(), forCellReuseIdentifier: GroupChannelListEditableTableViewCell.cellReuseIdentifier())
        
        // uncomment
//
//        userId = UserDefaults.standard.value(forKey: "user_id") as? String
//        print(userId!)
//        let filteredQuery = SBDGroupChannel.createMyGroupChannelListQuery()
//        filteredQuery?.setUserIdsIncludeFilter([userId!], queryType: SBDGroupChannelListQueryType.and)
//        filteredQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
//            // Only 'channelB' that include the ids {"John", "Jay", "Jin"} as a subset is returned.
//            print(groupChannels!)
//            self.channels = groupChannels!
//            print(self.channels)
//            print(self.channels.count)
//
//            if self.channels.count > 0 {
//                DispatchQueue.main.async {
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//
//                    self.tableView.reloadData()
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(150), execute: {
//                        self.showList()
//                    })
//                }
//            }
//            else {
//                self.cachedChannels = false
//                self.showList()
//            }
//
//        })
        
        
//        userId = UserDefaults.standard.value(forKey: "user_id") as? String
//        print(userId!)

        self.channels = Utils.loadGroupChannels()

      ///  self.refreshControl = UIRefreshControl()
//        self.refreshControl?.endRefreshing()

//        self.refreshControl?.addTarget(self, action: #selector(refreshChannelList), for: UIControl.Event.valueChanged)
//        self.tableView.addSubview(self.refreshControl!)
        
        self.setDefaultNavigationItems()
        
        self.noChannelLabel.isHidden = true
        
//        ConnectionManager.add(connectionObserver: self as ConnectionManagerDelegate)
//        if SBDMain.getConnectState() == .closed {
//            ConnectionManager.login { (user, error) in
//                guard error == nil else {
//                    return;
//                }
//            }
//        }
//        else {
//            self.firstLoading = false;
//            self.showList()
//        }
    }
    @IBAction func backVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showList() {
        let dumpLoadQueue: DispatchQueue = DispatchQueue(label: "com.biipbyte.dumploadqueue", attributes: .concurrent)
        dumpLoadQueue.async {
            self.channels = Utils.loadGroupChannels()
           
            if self.channels.count > 0 {
                DispatchQueue.main.async {
//                     self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)
//                      self.channels.remove(at:self.channels.count - 1)
//                    self.channels.remove(at:self.channels.count - 1)

                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(150), execute: {
//                  self.refreshChannelList()
                        
                    })
                }
            }
            else {
                self.cachedChannels = false
//                self.refreshChannelList()
            }
            self.firstLoading = true;
        }
    }
    
    deinit {
        ConnectionManager.remove(connectionObserver: self as ConnectionManagerDelegate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.dumpChannels(channels: self.channels)
    }
    
    func addDelegates() {
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
    }
    
    private func setDefaultNavigationItems() {
        let negativeLeftSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeLeftSpacer.width = -2
        let negativeRightSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeRightSpacer.width = -2
        
//        let leftBackItem = UIBarButtonItem(image: UIImage(named: "xibBack"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back))
//        let rightCreateGroupChannelItem = UIBarButtonItem(image: UIImage(named: "btn_plus"), style: UIBarButtonItem.Style.done, target: self, action: #selector(createGroupChannel))
        let rightEditItem = UIBarButtonItem(image: UIImage(named: "btn_edit"), style: UIBarButtonItem.Style.done, target: self, action: #selector(editGroupChannel))
        rightEditItem.imageInsets = UIEdgeInsets.init(top: 0, left: 14, bottom: 0, right: -14)
        
        self.navItem.leftBarButtonItems = [negativeLeftSpacer]
        self.navItem.rightBarButtonItems = [negativeRightSpacer, rightEditItem]
    }
    
    private func setEditableNavigationItems() {
        let negativeLeftSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeLeftSpacer.width = -2
        
        let leftBackItem = UIBarButtonItem(title: Bundle.sbLocalizedStringForKey(key: "DoneButton"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(done))
        leftBackItem.setTitleTextAttributes([NSAttributedString.Key.font: Constants.navigationBarButtonItemFont()], for: UIControl.State.normal)
        
        self.navItem.leftBarButtonItems = [negativeLeftSpacer, leftBackItem]
        self.navItem.rightBarButtonItems = []
    }
    
//    @objc private func refreshChannelList() {
//        self.groupChannelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
//        self.groupChannelListQuery?.limit = 20
//        self.groupChannelListQuery?.order = SBDGroupChannelListOrder.latestLastMessage
//
//        self.groupChannelListQuery?.loadNextPage(completionHandler: { (channels, error) in
//            if error != nil {
//                DispatchQueue.main.async {
//                    self.refreshControl?.endRefreshing()
//                }
//
//                return
//            }
//
//            self.channels.removeAll()
//            self.cachedChannels = false
//
//            for channel in channels! {
//                print(channel)
//                self.channels.append(channel)
//
//            }
//            print(self.channels)
//            DispatchQueue.main.async {
//                if self.channels.count == 0 {
//                    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//                    self.noChannelLabel.isHidden = false
//                }
//                else {
//                    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
//                    self.noChannelLabel.isHidden = true
//                }
//
//                self.refreshControl?.endRefreshing()
//                self.tableView.reloadData()
//            }
//        })
//    }
    
    private func loadChannels() {
        if self.cachedChannels == true {
            return
        }
        
        if self.groupChannelListQuery != nil {
            if self.groupChannelListQuery?.hasNext == false {
                return
            }
            
            self.groupChannelListQuery?.loadNextPage(completionHandler: { (channels, error) in
                if error != nil {
                    if error?.code != 800170 {
                        DispatchQueue.main.async {
//                            self.refreshControl?.endRefreshing()
                        }
                        
                        let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                        let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                        vc.addAction(closeAction)
                        DispatchQueue.main.async {
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    
                    return
                }
                
                for channel in channels! {
                    self.channels.append(channel)
                }
                
                DispatchQueue.main.async {
//                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @objc private func back() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func createGroupChannel() {
        let vc = CreateGroupChannelUserListViewController(nibName: "CreateGroupChannelUserListViewController", bundle: Bundle.main)
        vc.delegate = self
        vc.userSelectionMode = 0
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc private func editGroupChannel() {
        self.editableChannel = true
        self.setEditableNavigationItems()
        self.tableView.reloadData()
    }
    
    @objc func done() {
        self.editableChannel = false
        self.setDefaultNavigationItems()
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.editableChannel == false {
            let vc = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
            vc.groupChannel = self.channels[indexPath.row]
            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else {
            let cell = tableView.cellForRow(at: indexPath) as! MGSwipeTableCell
            cell.showSwipe(MGSwipeDirection.rightToLeft, animated: true)
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if self.editableChannel == true {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupChannelListEditableTableViewCell.cellReuseIdentifier()) as! GroupChannelListEditableTableViewCell?
            let leaveButton = MGSwipeButton(title: Bundle.sbLocalizedStringForKey(key: "LeaveButton"), backgroundColor: Constants.leaveButtonColor())
            let hideButton = MGSwipeButton(title: Bundle.sbLocalizedStringForKey(key: "HideButton"), backgroundColor: Constants.hideButtonColor())
            
            hideButton.titleLabel?.font = Constants.hideButtonFont()
            leaveButton.titleLabel?.font = Constants.leaveButtonFont()
            
            (cell as! GroupChannelListEditableTableViewCell).rightButtons = [hideButton, leaveButton]
            (cell as! GroupChannelListEditableTableViewCell).setModel(aChannel: self.channels[indexPath.row])
            (cell as! GroupChannelListEditableTableViewCell).delegate = self
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupChannelListTableViewCell.cellReuseIdentifier()) as! GroupChannelListTableViewCell?
            if self.channels[indexPath.row].isTyping() == true {
                if self.typingAnimationChannelList.index(of: self.channels[indexPath.row].channelUrl) == nil {
                    self.typingAnimationChannelList.append(self.channels[indexPath.row].channelUrl)
                }
            }
            else {
                if self.typingAnimationChannelList.index(of: self.channels[indexPath.row].channelUrl) != nil {
                    self.typingAnimationChannelList.remove(at: self.typingAnimationChannelList.index(of: self.channels[indexPath.row].channelUrl)!)
                }
            }
            
            (cell as! GroupChannelListTableViewCell).setModel(aChannel: self.channels[indexPath.row])
        }
        
        if self.channels.count > 0 && indexPath.row + 1 == self.channels.count {
            self.loadChannels()
        }
//        self.refreshControl?.endRefreshing()

        return cell!
    }
    
    // MARK: MGSwipeTableCellDelegate
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        // 0: right, 1: left
        let row = self.tableView.indexPath(for: cell)?.row
        let selectedChannel: SBDGroupChannel = self.channels[row!] as SBDGroupChannel
        if index == 0 {
            // Hide
            selectedChannel.hide(withHidePreviousMessages: false, completionHandler: { (error) in
                if error != nil {
                    let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                    let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                    vc.addAction(closeAction)
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    return
                }
                
                if let index = self.channels.index(of: selectedChannel) {
                    self.channels.remove(at: index)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        else {
            // Leave
            selectedChannel.leave(completionHandler: { (error) in
                if error != nil {
                    let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                    let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                    vc.addAction(closeAction)
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    return
                }
                
                if let index = self.channels.index(of: selectedChannel) {
                    self.channels.remove(at: index)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        return true
    }
    
    // MARK: CreateGroupChannelUserListViewControllerDelegate
    func openGroupChannel(channel: SBDGroupChannel, vc: UIViewController) {
        DispatchQueue.main.async {
            let vc = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
            vc.groupChannel = channel
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    // MARK: GroupChannelChattingViewController\
    func didConnect(isReconnection: Bool) {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        let bestVC = Utils.findBestViewController(vc: vc!)
        
        if bestVC == self {
//            self.refreshChannelList()
        }
    }
    
    func didDisconnect() {
        //
    }
    
    // MARK: SBDChannelDelegate
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender is SBDGroupChannel {
            let messageReceivedChannel = sender as! SBDGroupChannel
            if self.channels.index(of: messageReceivedChannel) != nil {
                self.channels.remove(at: self.channels.index(of: messageReceivedChannel)!)
            }
            self.channels.insert(messageReceivedChannel, at: 0)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        
    }
    
    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
        if self.editableChannel == true {
            return
        }
        
        let row = self.channels.index(of: sender)
        if row != nil {
            let cell = self.tableView.cellForRow(at: IndexPath(row: row!, section: 0)) as! GroupChannelListTableViewCell
            
            cell.startTypingAnimation()
        }
    }
    
    func channel(_ sender: SBDGroupChannel, userDidJoin user: SBDUser) {
        DispatchQueue.main.async {
            if self.channels.index(of: sender) == nil {
                self.channels.append(sender)
            }
            self.tableView.reloadData()
        }
    }
    
    func channel(_ sender: SBDGroupChannel, userDidLeave user: SBDUser) {
        if user.userId == SBDMain.getCurrentUser()?.userId {
            if let index = self.channels.index(of: sender) {
                self.channels.remove(at: index)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func channel(_ sender: SBDOpenChannel, userDidEnter user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDOpenChannel, userDidExit user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasMuted user: SBDUser) {
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnmuted user: SBDUser) {
    }
    
    func channel(_ sender: SBDBaseChannel, userWasBanned user: SBDUser) {
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnbanned user: SBDUser) {
    }
    
    func channelWasFrozen(_ sender: SBDBaseChannel) {
    }
    
    func channelWasUnfrozen(_ sender: SBDBaseChannel) {
    }
    
    func channelWasChanged(_ sender: SBDBaseChannel) {
        if sender is SBDGroupChannel {
            let messageReceivedChannel = sender as! SBDGroupChannel
            if self.channels.index(of: messageReceivedChannel) != nil {
                self.channels.remove(at: self.channels.index(of: messageReceivedChannel)!)
            }
            self.channels.insert(messageReceivedChannel, at: 0)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func channelWasDeleted(_ channelUrl: String, channelType: SBDChannelType) {
        
    }
    
    
    func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
        
    }
}
