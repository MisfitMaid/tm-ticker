$7z = "C:\Program Files\7-Zip\7z"
if (test-path ticker.op) { rm ticker.op -verbose }
& $7z a -tzip ticker.op *.as info.toml LICENSE
