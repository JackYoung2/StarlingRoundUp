//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation
import Common

public enum APIError: Error {
    case networkError
    case parsingError
}

public protocol APIClientProtocol {
//    var decoder: JSONDecoder { get set }
    var loadData: (URLRequest) async throws -> (Data, URLResponse) { get set }
    func call<Value: Decodable>(_ endpoint: inout Endpoint<Value>) async throws -> Result<Value, APIError>
}

//func data(for request: URLRequest) async throws -> (Data, URLResponse)

public struct APIClient: APIClientProtocol  {
    
    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.isoDateFormatter)
        return decoder
    }
    
    public var loadData: (URLRequest) async throws -> (Data, URLResponse)
    
    var dataTask: (URLRequest) async throws -> (Data, URLResponse) = { request in
        try await URLSession.shared.data(for: request)
    }
    
    
    public init(
        decoder: JSONDecoder? = nil,
        loadData: ( (URLRequest) -> (Data, URLResponse))? = nil
    ) {
        self.loadData = loadData ?? dataTask
    }
    
    public func call<Value: Decodable>(_ endpoint: inout Endpoint<Value>) async throws -> Result<Value, APIError> {
        endpoint.headers["Authorization"] = "Bearer \(authToken)"
        endpoint.headers["User-Agent"] = userAgent
        
        guard let (data, _) = try? await loadData(endpoint.urlRequest()) else {
            return .failure(.networkError)
        }
        
//        TODO: - Handle response codes
        
        do {
            let result = try decoder.decode(Value.self, from: data)
            return .success(result)
        } catch {
            print(error)
            return .failure(.parsingError)
        }
    }
}

var authToken = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty47bMAz8lcLn5cJ2_Mytt_5AP4Ai6URYWzIkOdtF0X-v_EgcB3sJPDPkkBSZv4n2PjknOGpgGey7D-h6bS4Kzcc72SF5S_ykYgSlbZkzNZBWxFDkeQdtWdeQFVQUiqVu2ywGy58xOWd1WtZlW5b5W6IxrERVn7KZQCI7mfDL9izut-bNm7KmBVZtAwXmDE0lTfxRbaFOHZ2oit7BfojZMqqKK9UpSNOYtnSDWVtBkaUldVJiwypmxLF-Eon3e502xwLymhQUfBJoVJ3CKZOcFLVFxjwPTHaU-VHWTuG6tAoGBzk7Qf7xIoSv8UXQLCboTos78r324cBsgNnFJs_COjzAqoSAdB3kETmFq3Xaxw2BNqxvmifsV01hj4a2TggdA1kTnO1X35nZNGs67QYM2hqwHXST4a0eTT7Y4d62DKi37AENY5AzSy9BHnAJGyRgRHimCGfxjpfMEb9E7tIKNpMV7EGgB7xsnqu2f0JwaDzS3PODht5SnH73Xgmw8zO8sluWs53u76XW2gdqiXJCosdwAP4ofTod3T3e4io8XOzex4HbRj1wi88zsw7XxWf_xmIXv_HaxdWUrsJTLwxx7P1qvIQQB5zGDY54P5P4d49XFI_JOn4qf2TvdY_sN_lgP82DDzI3AORvr9TI3Uo973RZxeuSk3__ASMDejahBAAA.ZkGskeGj09Siw7s-r_lvg5O4vUrP4VBNMdpr8-risXmTGa8K0kV9PaD6Mbr0da4sxpRYhk87LBmm4cZVJY5IRvt--bwarZsk7SI0JBvs4plOLtbMXu8TfvW-0t6QQ9oENrd7Pg_YcpieqwGp7tjn2PNA4jirYaCQ2YjbMgptW-pNzDYNrl1rRcqyD6nlSJwRBUrIzp9vJcoj2CX1Zfeg6rhdgSpf8YsHjpuXw5AVOsxGUVHBXJ44dEt-XwSTgfgvOd5Hhr_oKzVZrlTqVfn6-_4LkHVuWIkqMoJppAmoswclhSpLhr7yoA5VfTtr6SEiGNkqW3pZHt29PIhP3nKJ1yJvg5LekreOwUQQgk4k8EfJ0EGFoftFBOsDWj5u4KAMSbicCQUxCetx-u5_p2_wOtY4mkA0fJkuq_l_tDEIqOyv10d0SuZTeSNOIK7zXnmc5QZMOK3EKHCVwrdFKHzihOrpyTlcxWQwQ7WzRBipf3n7ao0X2AZS5O1xh6QdW2PPDTFdHsbGFbX2Lb65u_JsBcWdb_h4vcfPCx79fcBIR7P_csW1FyMThPXMzHShBK-QVmbNfEDLrE2ouHwXQg4rrqoLu8IbYX1bwMM8wSm5Dm3kofx0GB5RzIvrHj_O2tuHineWDP9bsKqk0G6c2-yxGm6LoCzZ4gwqZ6Vyf0uBOps"

var userAgent = "Jack-Young"
