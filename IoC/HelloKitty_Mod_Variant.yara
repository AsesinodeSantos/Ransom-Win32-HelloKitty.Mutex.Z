
rule HelloKitty_Mod_Variant
{
    meta:
        author = "Defensive Research"
        description = "Detects modded HelloKitty ransomware with updated magic bytes and obfuscation"
        malware_family = "HelloKitty"
        last_updated = "2025-09-08"

    strings:
        $magic = /HK..TY/ nocase
        $rsa_pub = "RSA-2048"
        $salsa = "Salsa20"
        $file_ext = /.crypt$|.locked$|.enc$/
        $vssadmin = "vssadmin.exe"

    condition:
        any of ($magic, $rsa_pub, $salsa, $vssadmin) or $file_ext
}
