//
//  RSSFeedsPresenter.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import Foundation

protocol RSSFeedsPresenter : class  {
    
    init(view : RSSFeedsView)
    
    func configure(cell : RSSFeedsTableViewCell, at indexPath : IndexPath)
    func viewDidLoad()
    func registerNewRSSFeed(urlString : String)
    func logout()
    func selectedRSS(at indexPath : IndexPath)
    var rssfeeds : [RSSFeeds] { get set }
    
}

class RSSFeedsPresenterImp : RSSFeedsPresenter {
    

    private weak var view : RSSFeedsView?
    public var rssfeeds : [RSSFeeds] = []
    
    lazy var accessToken : String? = {
        UserSession.getUserToken()
    }()
    
    required init(view: RSSFeedsView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchRSSFeeds()
    }
    
    func configure(cell: RSSFeedsTableViewCell, at indexPath: IndexPath) {
        let rssFeed = rssfeeds[indexPath.row]
        cell.configure(title: rssFeed.title)
        cell.configure(url: rssFeed.url)
    }
    
    func registerNewRSSFeed(urlString: String) {
        guard let _ = URL(string: urlString) else {
            return
        }
        requestSubscribeRSSFeed(url: urlString)
    }
    
    func logout() {
        UserSession.endSession()
        view?.endViewController()
    }
    
    func selectedRSS(at indexPath: IndexPath) {
        let rss = rssfeeds[indexPath.row]
        view?.presentArticlesView(with: rss)
    }
    
    func fetchRSSFeeds() {
        guard let token = accessToken else {
            return
        }
        let restClient = RestClientService(urlBase: "167.99.162.146")
        restClient.dataRequest(endpoint: "/feeds",
                               method: .GET,
                               token: token,
                               returnType: RSSSubscribedResponse.self,
                               completionHandler: { [weak self] rssFeeds in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.rssfeeds = rssFeeds
                                strongSelf.view?.loadData()
                               },
                               errorHandler: { [weak self] error in
                                    print(error)
                               })
    }
    
    func requestSubscribeRSSFeed(url : String) {
        
        guard let token = accessToken else {
            return
        }
        let body = RequestSubscribeRSSFeed(url: url)
        let restClient = RestClientService(urlBase: "167.99.162.146")
        restClient.dataRequest(endpoint: "/feeds/add",
                               body: body,
                               method: .POST,
                               token: token,
                               returnType: RSSFeeds.self,
                               completionHandler: { [weak self] rssFeed in
                                guard let strongSelf = self else {
                                    return
                                }
                                self?.rssfeeds.append(rssFeed)
                                strongSelf.view?.loadData()
                               },
                               errorHandler: { [weak self] error in
                                    self?.fetchRSSFeeds()
                               })
    }
}
