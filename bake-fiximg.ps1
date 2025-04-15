Set-PSDebug -Strict

. .\bake.ps1

bake "." ".\docs" {
    param($from,$to)
    nkf32 -w $from | perl -pe 'binmode(STDIN);binmode(STDOUT);s|"http://hp.vector.co.jp/authors/VA009797|"https://hymkor.github.io/hp.vector.co.jp_VA009797|g' > $to
}
