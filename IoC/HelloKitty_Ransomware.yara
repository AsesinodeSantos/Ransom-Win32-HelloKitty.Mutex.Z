
rule HelloKitty_Ransomware
{
    meta:
        author = "Synthetic Threat Detection"
        description = "Detects HelloKitty ransomware binaries based on encryption routines, file magic bytes, and behavior patterns"
        malware_family = "HelloKitty"
        last_updated = "2025-09-08"

    strings:
        $magic = { 48 4B 49 54 54 59 } // "HKITTY" magic string in encrypted files
        $rsa_pub = "RSA-2048"
        $salsa = "Salsa20"
        $xor_seed = "XORSeed"
        $process_injection = "vssadmin.exe"
        $file_ext = ".locked"

    condition:
        any of ($magic, $rsa_pub, $salsa, $xor_seed, $process_injection) or $file_ext
}
