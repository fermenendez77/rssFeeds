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
    
    var rssfeeds : [RSSFeeds] { get set }
    
}

class RSSFeedsPresenterImp : RSSFeedsPresenter {
    
    
    
    private var view : RSSFeedsView
    
    public var rssfeeds : [RSSFeeds] = []
    
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

    func getAccessToken() -> String? {
        if let user = UserDefaults.standard.data(forKey: "userLogged") {
            if let decoded = try? JSONDecoder().decode(LoginResponse.self, from: user) {
                return decoded.accessToken
            }
        }
        return nil
    }
    
    func fetchRSSFeeds() {
        guard let token = getAccessToken() else {
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
                                strongSelf.view.loadData()
                               },
                               errorHandler: { [weak self] error in
                                    print(error)
                               })
    }
}
