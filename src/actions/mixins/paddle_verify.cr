module PaddleVerify
  def verify_sign(params)
    signature = Base64.decode(params["p_signature"].to_s)

    params.delete("p_signature")
    stringify_data = Hash(String, String).new
    params.each { |key, value| stringify_data[key.to_s] = value.to_s }

    serialized_data = stringify_data.to_php_serialized
    rsa = OpenSSL::PKey::RSA.new(File.read("./paddle_key.pem"))
    digest = OpenSSL::Digest.new("sha1")
    rsa.verify(digest, signature, serialized_data)
  end
end
