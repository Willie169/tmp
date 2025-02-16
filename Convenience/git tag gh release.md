git tag -a v1.1 -m 'Release version 1.1'
git push origin v1.1
gh release create v1.1 com.willie.mancala_11.apk --title 'Release version 1.1' --notes 'See <https://github.com/Willie169/mancala-android/issues/1>.'

git tag -d v1.0.0
git push origin --delete v1.0.0

git tag -a v1.0.0 -m 'Version 1.0.0 release'
git push origin v1.0.0
gh release create v1.0.0 --title 'Version 1.0.0 release' --notes ''

git tag v1.0.0 577dd01^{} -m 'Version 1.0.0 release'
git push origin v1.0.0
gh release create v1.0.0 --title 'Version 1.0.0 release' --notes '- Initial release.'

Release have to be deleted manually 