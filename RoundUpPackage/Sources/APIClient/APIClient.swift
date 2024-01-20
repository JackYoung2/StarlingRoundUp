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

var authToken = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21TQZKjMAz8yhbn0RQQJ-Dc9rYf2AcISUxcAzZlm8xObe3f18QkDKm5pOhuqSVZyt_ChFCcC5wMsIzuNUT0g7FvHdr3V3Jj8VKEuUsRVOpjzdRCeSIGVdc96GPTQKVIqY6l0bpKwfJnKs5VUx5bdSp1-VIYjJlojvq0EEjkZht_uYHF_za8elPVauBOt6CwZmhP0qafTqvu0NOBTsk7unexawZVpTSi4MhdD-qgNXSHUqASohNWTX-sVMpIY_0kkhC2OrpGBXVDHSg-CLRdU8Khkpo60qpiXgYmN8nyKLlTuNxaBYujnL0g_3gS4uf0JBgWG01vxO_5wYS4Y1bA7FOTZ2ETHyArMSJdRnlEzvHivAlpQ2Asm6vhGYesdTigpbUTQs9Azkbvhuy7MKvmbG_8iNE4C66Hfra81qM5RDfe25YRzZo9omWMcmYZJMoD3sJGiZgQninBRbzjW-aEnyJ3KYPVJIMtCMyIb6tn1rZPiB5tQFp6ftAwOErTb96ZALc8wzO7ZnnXm-FeKtfeUbcoLyRmijsQ9tKHN8k94DWtIsCb2_rYceuoO-7m85XJw_Xp2b-x2MRvvDYxm9JFeB6EIY29XU2QGNOA87TCCe9nkv7u6YrSMTnPX8rv2XvdPftNPrgP--CjLA0AheszNXGfqa87va3iecnFv_8lLvYtoQQAAA.Df3OHy1zT8ztTIKJolq_97KyztnxPWIIqwoIx4E978DbuHGDAsUjJE4fRF6aGyx56cczu2rXcooq2gEHmhevPi1dt78ytp2qT46GFZ1TvIw5NNjVz7dc_nYLkvOZrmj_KM6uipYCdAfW2SqBP9xe85AYN0tWLYm86UNtw1Q0Djq1qps8cW5ZuPGXJqF3-c_NGQKVh6OC5zWn1oBpyn5d1YkGmQDk67pGzw1yzac0Fi95xRQgCZUBf1FVtBIqQwbUR79oudgkdI0ShMWQ9s3eXorwWRPfnuYOJl1Gn9XEPtni0kIxXCQKskVuzznvlVhPoZclUDAhw-c4Z5ss-1gYcUBDU-8wPK3wj76UJj6NYEU_GxSIHTgslOI5z1JCD7UlBkxRSOuNe3pK6p5N5qWWYDg8Ngu0BjmGxS_Af2S3kJM6wvHyHc7da5B4P04M1lzldJgjZ_IqHy9IA1-nV-NDQvURpB-l6xPsCxsO9qKt6uarCetG_f8obdhnTnswE7TmeVO6_lswt2-ltPkmnlgblodn36pdSAo7xsqlFL3gQ5ijdDRUP0qOtYsdM7OJz2G5t1YQ9YxSn4-onJwm7Enuw9uc1VOy5d5P_xvQrgJHTs1JnitrYbW2qynq-LCNVOPc4OmqTUiEON4tkyI5RqfIspE1z42Q8e8kyy8Hx1eZ98k"

var authToken2 = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty5KjMAz8lS3OoymeIXDb2_7AfoAsy4lrwKZsk9mprf33NZiEkJob3S21JEv8zbT3WZ_hpEHyaN99QDdocxFoPt7Jjtlb5mcRI4i4LVRVQaHKCupzxyBQVdDl2JRnodoCTzGY_0xZX7R5c27OXde9ZRpDItq2bBYCiexswi87SHa_tdy8O6kISqLoXdPiXecgu6LsKi5J5hS9g_1gs2eUzakEVQkBdV42IBQKOCOrnDpRFE0RM-JYP2Oo93uWqoUCUeIJ6qpuQdQNQ9ep8lQRoWJeBiY78fIoqVO4rq2CwZF7xyh_vAjha3oRtGQTtNLsjvygfTgwG5DSxSZ7ljo8QFJCQLqO_Iicw9U67eOGQBupb1rOOCRN4ICGtk4InQSyJjg7JN-F2TRrlHYjBm0NWAVqNnKrR7MPdry3zSPqLXtEIzFwL3ngwA-4ho0cMCLsKcJFvOM1c8Iv5ruUwGaSwB4EesTL5pm0_ROCQ-ORlp4fNAyW4vS7dyLALs_wym5Zzio93Eul2gdqjXJMrKdwAP4ofTod3T3e4io8XOzex4HbRj1wq88zk4ZT8dm_sdjFb7x2MZnSleU8sIQ49n41nkOIA87TBie8n0n83eMVxWOyTj6VP7L3ukf2m3ywn-bBB14aAPK3V2qSKlHPO11X8brk7N9_80OV6KEEAAA.LXFyvT2Me7iWeILN7Aq1oCV4A_Rx8M618NQ1aRaFKwcgEQJfwRE8qySWWCi5bO1L0iRKrwdVRIP_5NjWhzox9bHBLFC1eeoZ1zjFCG1kLzETP1ilaoNMuDf1kMxHIJ9nktyxvwhtFoRKFvZ4nQuR-lTbx1rHEE_em45Xma9Ut5T5d-_hu_-iWc3WA4AMNByyCiWEeUnh4uqZLrTbwslfhN6Afm1bf3GdH1X1yzdVwxRCaNfxN8v4__5h1eJWx0n3hRTqHbjq3vIMFr94aZIk_I17URwxAfRbDVsRP8n1z9ywS-_S8qX2NqCSEmUBV9KLI1JA_d4BcUtBUBAWO9gPF6v75IcO55RkaVL7qgNmJ9xU-xVp3GL2WOWpeE1yOl9iU4_lejjq4OpUozJ9FYRYxagESPZMk2xTH4XZdvj5V1HeE4Y9XoxF3NcKfaQr3KLYoQksGhOmpBVnlX-nuJKlkH-cJwScPMG6lic_9UmQ0-0GpfA0eKICBCi4I0hSYaE1NhKMkkOywpSAkTqVjLWgupwrjI08JZdkVOFARsAVURnwXppGMdQ1LQaqcxjwEGQUORGyn0zSd-a55qD9peIjXswjHaE946DkdM4A3n_q9z-7803S5e4DGtLUOPnKG6s1AzU51XG7DL_Kzfy7Y8kud0ia2rRg6Bbwyu4gmvZ0Fr4"

var userAgent = "Jack-Young"
