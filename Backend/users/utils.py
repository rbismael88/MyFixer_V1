from .models import User

def verify_client_documents(user: User) -> bool:
    """
    Verifica los documentos de un usuario tipo cliente.
    Un cliente necesita la foto de perfil y la cédula de identidad verificada.
    """
    if user.user_type == "client":
        if user.profile_picture and user.identity_card and user.identity_card_verified:
            return True
    return False

def verify_provider_documents(user: User) -> bool:
    """
    Verifica los documentos de un usuario tipo proveedor.
    Un proveedor necesita la foto de perfil, la cédula de identidad y el certificado de antecedentes penales verificados.
    """
    if user.user_type == "provider":
        if user.profile_picture and \
           user.identity_card and user.identity_card_verified and \
           user.criminal_record_certificate and user.criminal_record_certificate_verified:
            return True
    return False

def is_user_verified(user: User) -> bool:
    """
    Verifica si un usuario ha completado la verificación de documentos según su tipo.
    """
    if user.user_type == "client":
        return verify_client_documents(user)
    elif user.user_type == "provider":
        return verify_provider_documents(user)
    return False
