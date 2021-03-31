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
    /* IP Address has been changed */
    static let BASE_URL_SERVICE = "http://54.255.115.196/sharent_new/index.php/"
    static let BASE_URL = "http://54.255.115.196/sharent_new/"
    
    //Live
    //    static let BASE_URL_SERVICE = "https://shserv.sharent.com.sg/index.php/"
    //    static let BASE_URL = "https://shserv.sharent.com.sg/"
    
    static let API_KEY = "tz6n5M+lnJVw007muIr7UXATrR4quD9V4Z+upTXcDXWzD7LE1eZaHdcyBe/Z3TjChzPdgS5dKvVIQm6gq6HVuw=="
    
    static let APP_VERSION = "register_user/get_app_version"
    static let CREATE_ACCOUNT = "register_user/create_user"
    static let CREATE_MERCHANT = "register_user/create_merchant"
    static let VERIFY_ACCOUNT = "register_user/verify_mobile"
    static let REGISTER_TERMS_CONDITIONS = "welcome/terms_conditions"
    static let SERVICE_AGREEMENT = "welcome/agreement"
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
    static let GET_ALL_PRODUCTS_BUYER = "category/home"
    static let GET_ALL_PRODUCTS_MERCHANT = "category/home_merchant"
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
    static let USER_FAQ = "faq"
    static let MERCHANT_FAQ = "faq-merchant"
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
    
   
      // recently added
    static let GET_HOT_PRODUCTS = "products/get_hot_products"
    static let GET_BANNER_DETAILS = "products/get_banner_details"
    static let GET_SEARCH_BY_TAGS = "products/search_by_category_tags"
    static let ADDTO_CART = "products/add_cart"
    static let GET_CART_ITEMS = "products/cart_items"
    static let DELETE_CART_ITEM = "products/delete_cart_items"
    static let CART_SUMMARY = "products/cart_summary"
    static let CHECK_PROMOCODE = "products/check_promocode"
    static let RELATED_PRODUCTS = "products/related_products"
    static let ORDER_PLACE = "products/placing_order"
    static let PAYMENT_HISTORY = "products/payment_history"
    static let EDIT_CART_ITEM = "products/edit_cart"
    static let UPDATE_CART_ITEM = "products/edit_update_cart"
    static let BOOKING_DETAILS_INSERT = "products/update_cart"
    static let MERCHANT_ACTIVATE_ORDER = "merchants/merchant_accept"
    static let MERCHANT_EDIT_ITEM = "merchants/edit_product"
    static let VERIFY_EMAIL_ACCOUNT = "register_user/verify_email"
    static let RESEND_VERIFY_CODE = "register_user/resend_verifycode_email"
    static let LALAMOVE_DELETE_CARD = "lalamove/delete_card"
    static let MERCHANT_EMAIL_RECEIPT = "merchants/email_receipt"
    static let MERCHANT_CREATE_IMAGES = "products/create_images"
    static let SOCIAL_MEDIA_LOGIN = "register_user/fb_gmail_user"
}

class ApiManager
{
    func postRequest(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion("The Internet connection appears to be offline.",false)
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
                   
                    let status = "\(String(describing: response["status"]!))"
                    
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
    
    func postRequestwithImages(service:String,images:[String:UIImage],params: [String:String], completion: @escaping (_ result:Any,_ success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion("The Internet connection appears to be offline.",false)
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in images
            {
                
                multipartFormData.append(UIImageJPEGRepresentation(value, 0.8)!, withName:key, fileName:"\(key).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: serviceUrl!,
           
           encodingCompletion: { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON
                    { (response:DataResponse) in
                        switch response.result
                        {
                        case .success( _):
                            print(response.result.value as! [String : Any])
                            let jsonResponse = response.result.value as! [String : Any]
                            let response = jsonResponse["response"] as! [String:Any]
                          
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
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // edit profile image uploading in mulitpart form
    func editProfileSendRequest(service: String, image:UIImage ,params: [String: String], completion: @escaping (_ result:Any,_ Success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion("The Internet connection appears to be offline.",false)
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.7)!, withName:"profile_image", fileName: "profileImage.jpg", mimeType: "image/jpeg")
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: serviceUrl!,
           
           encodingCompletion: { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON
                    { (response:DataResponse) in
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
            case .failure(let error):
                print(error)
            }
            
        })
        
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
    
}
