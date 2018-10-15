//
//  ApiManager.swift
//  Sharent
//
//  Created by Biipbyte on 29/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import Foundation
import Alamofire

struct WebServices
{
    //Test
    static let BASE_URL_SERVICE = "http://54.151.221.7/sharent_new/index.php/"
    static let BASE_URL = "http://54.151.221.7/sharent_new/"
    //Live
//    static let BASE_URL_SERVICE = "http://shserv.sharent.com.sg/index.php/"
//    static let BASE_URL = "http://shserv.sharent.com.sg/"
    
    static let API_KEY = "tz6n5M+lnJVw007muIr7UXATrR4quD9V4Z+upTXcDXWzD7LE1eZaHdcyBe/Z3TjChzPdgS5dKvVIQm6gq6HVuw=="
    static let CREATE_ACCOUNT = "register_user/create_user"
    static let VERIFY_ACCOUNT = "register_user/verify_mobile"
    static let REGISTER_TERMS_CONDITIONS = "welcome/terms_conditions"
    static let LOGIN_ACCOUNT = "register_user/login"
    static let FCMREGISTRATION_USER = "gcmpush/storeUser"
    static let FCMDEREGISTRATION_USER = "gcmpush/logout_gcm"
    static let RESEND_OTP = "register_user/resend_verifycode_mobile"
    static let FORGOTPASSWORD_ACCOUNT = "register_user/forgot_password"
    static let FORGOTPASSWORD_VERIFY_OTP = "register_user/verify_forgot_password"
    static let RESET_PASWORD = "register_user/set_newpassword"
    static let EXISTING_EMAIL_CHECKING = "register_user/check_email_exist"
    static let REGISTER_ACCOUNT_GMAIL = "register_user/gmail_user"
    static let REGISTER_ACCOUNT_FACEBOOK = "register_user/fb_user"
    static let GET_ALLHOME_CATAGORIES = "category/home"
    static let GET_ALL_CATAGORIES = "category/get_category"
    static let CREATE_PRODUCT = "products/create"
    static let GET_ALL_PRODUCTS_BYCATAGORY = "products/get_product_by_category"
    static let GET_PRODUCT_DETAILS = "products/product_details"
    static let MERCHANT_PRODUCT_DETAILS = "merchants/product_details"
    static let GET_MYBOOKINGS = "products/buyer_current_history"
    static let HISTORY_PRODUCTDETAILS = "products/buyer_history_details"
    static let MAKE_PRODUCT_FAVOURITE = "products/favourite_product"
    static let MAKE_PRODUCT_UNFAVOURITE = "products/unfavourite_product"
    static let GET_USERDETAILS = "register_user/get_user"
    static let PRIACY_POLICY = "welcome/privacy_policy"
    static let TERMS_OF_USE = "welcome/terms_conditions"
    static let CONTACT_US = "register_user/contact_us" 
    static let FAQ = "welcome/faq"
    static let CATEGORIES = "category/get_category"
    static let APPLY_PROMOCODE = "products/check_promocode"
    static let PROCEED_ORDER = "lalamove/quotation"
    static let PLACE_ORDER = "lalamove/place_order"
    static let UPDATE_ORDER = "lalamove/update_order"
    static let FAV_PRODUCTS = "products/get_favourite_products"
    static let BUYER_HISTOREY = "products/buyer_history"
    static let BUYER_HISTORY_DETAILS = "products/buyer_history_details"
    static let BUYER_SUBMIT_RATING = "products/write_review"
    static let MERCHANT_PRODUCT_REVIEWS = "products/get_review_merchant"
    static let BUYER_EDIT_PROFILE = "register_user/edit_user"
    static let MERCHANT_EDIT_PROFILE = "register_user/edit_merchant"
    static let CANCEL_OREDR = "products/cancel_order"
    static let BUYER_CONFIRM_ORDER = "lalamove/confirm_user"
    static let BUYER_CONFIRM_RETURN = "lalamove/confirm_status"
    static let MERCHANT_CONFIRM_ORDER = "lalamove/confirm_merchant"
    static let MERCHANT_CONFIRM_COLLECTED = "merchants/update_status"
    static let BUYER_CHANGE_PASSWORD = "products/cancel_order" //Need to add'
    static let PRE_AUTH_EMAIL_CHECK = "register_user/pre_email_check"
    static let PRE_AUTH_MOBILENUMBER_CHECK = "register_user/pre_mobile_check"
    static let PRE_AUTH_OTP_CHECK = "register_user/pre_otp_check"
    static let PRE_SIGNUP_PASSWORD_SET = "register_user/pre_create_password"
    static let CHANGE_PASSWORD = "register_user/change_newpassword"
    static let SEE_ALL_REVIEWS = "products/get_review"
    static let MY_REVENUE_DETAILS = "merchants/revenue_details"
    static let BUYER_SETTINGS = "register_user/notifications"
    static let BUYER_SETTINGS_UPDATE = "register_user/update_notifications"
    static let LALAMOVE_PRODUCT_STATUS = "products/buyer_shipping_status"
    
    static let LALAMOVE_GET_RECENT_CARD = "lalamove/get_recent_card"
    static let LALAMOVE_GET_ALL_CARDS = "lalamove/get_all_card"
    static let LALAMOVE_ADD_NEW_CARD = "lalamove/stripe_add_card"

}

class ApiManager
{
    func postRequest(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion(ResponceCodes.NoInternet,false)
            return
        }
        
        Alamofire.request(serviceUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
            {(response:DataResponse) in
                
                switch response.result
                {
                case .success( _):
                    print(response.result.value as! [String : Any])
                    let jsonResponse = response.result.value as! [String : Any]
                    let response = jsonResponse["response"] as! [String:Any]
                    print(response)
                    
                    let status = "\(String(describing: response["status"]!))"
                    print(status)
                    let message = response["message"] as! String
                     switch Int(status)
                    {
                    case 0:
                        completion(message,false)
                        break
                    case 1:
                        completion(response,true)
                        break
                    default:
                        print(status)
                    }
                    break
                case .failure(let error):
                    
                    completion(error.localizedDescription,false)
                    break
               }
          }
        }
    // edit profile image uploading in mulitpart form
    func editProfileSendRequest(_ url: String, image:UIImage ,parameters: [String: String], completion: @escaping (_ result:Any,_ Success:Bool) -> ()) {
        
        guard let mediaImage = Media(withImage:image, forKey: "profile_image") else { return }
        
        guard let urlString = URL(string: url) else { return }
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(json,true)
                } catch {
                    completion(error,false)
                }
            }
            }.resume()
        
    }
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data
    {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)" + "\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
}
   
enum ResponceCodes
{
    case success, authError, badRequest, requestTimeOut, internalServerError, serviceUnavailable, notFound, forbidden, OtherError, NoInternet
    
    func GetResponceCode() -> Int
    {
        var result: Int = 0
        switch self
        {
        case .success:
            result = 200
        case .authError:
            result = 401
        case .badRequest:
            result = 400
        case .requestTimeOut:
            result = 408
        case .internalServerError:
            result = 500
        case .serviceUnavailable:
            result = 503
        case .notFound:
            result = 404
        case .forbidden:
            result = 403
        case .NoInternet:
            result = 007
        case .OtherError:
            result = 0
        }
        return result
    }
}

extension Int
{
    func FetchError() -> ResponceCodes
    {
        switch self
        {
        case 200:
            return .success
        case 401:
            return .authError
        case 400:
            return .badRequest
        case 408:
            return .requestTimeOut
        case 500:
            return .internalServerError
        case 503:
            return .serviceUnavailable
        case 404:
            return .notFound
        case 403:
            return .forbidden
        case 007:
            return .NoInternet
        default:
            return .OtherError
        }
    }
}
extension Data
{
    mutating func append(_ string: String)
    {
        if let data = string.data(using: .utf8)
        {
            append(data)
        }
    }
}
