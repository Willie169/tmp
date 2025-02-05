git tag -a v1.0 -m 'Release version 1.0'
git push origin v1.0
gh release create v1.0 com.willie.mancala.apk --title 'Release version 1.0' --notes 'Initial release.'

git tag -a v1.0.0 -m 'Version 1.0.0 release'
git push origin v1.0.0
gh release create v1.0.0 --title 'Version 1.0.0 release' --notes ''

git tag -d v1.0.0
git push origin --delete v1.0.0

git tag v1.0.0 577dd01^{} -m 'Version 1.0.0 release'
git push origin v1.0.0
gh release create v1.0.0 --title 'Version 1.0.0 release' --notes '- Initial release.'

Release have to be deleted manually 