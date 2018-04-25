set -e
    
if [[ "$COVERAGE" == "true" ]] && [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    # Need to run coveralls from a git checkout, so we copy .coverage
    # from TEST_DIR where nosetests has been run
    cp $TEST_DIR/.coverage $TRAVIS_BUILD_DIR
    cd $TRAVIS_BUILD_DIR
    # Ignore coveralls failures as the coveralls server is not
    # very reliable but we don't want travis to report a failure
    # in the github UI just because the coverage report failed to
    # be published.
    pip install coveralls
    coveralls || echo "Coveralls upload failed"
fi

if [[ "$DEPLOY_WHEEL" == "true" ]]; then
    cd $TRAVIS_BUILD_DIR
    rm -rf dist/

    pip install twine
    if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
        # Build & Deploy sdist
        python setup.py sdist --formats=zip 
        twine upload dist/*.zip || true
    fi

    # Deploy wheels
    twine upload $WHEEL_FOLDER/*.whl || true
fi
