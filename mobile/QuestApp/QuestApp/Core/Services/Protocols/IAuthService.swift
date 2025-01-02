protocol IAuthService {
    func login(model: AuthRequestModel, onSuccess: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void)
    func register(model: AuthRequestModel, onSuccess: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void)
    func validateToken(completion: @escaping (Result<Void, Error>) -> Void)
} 