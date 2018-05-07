#
# Copyright 2016 Afero, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SANGO = sango
RESULTS_IOS = results_ios
RESULTS_TESTS = results_tests
RESULTS_ANDROID = results_android

all:
	@echo "Example to build sango data for iOS, Android and Test Automation used for testing."
	@echo " build_test_automation"
	@echo " build_ios"
	@echo " build_android"
	@echo " build_all"
	@echo " validate"

clean:
	@rm -rdf $(RESULTS_TESTS)
	@rm -rdf $(RESULTS_IOS)

build_test_automation:
	@rm -rdf $(RESULTS_TESTS)
	$(SANGO) -config config_tests.json -verbose

build_ios:
	@rm -rdf $(RESULTS_IOS)
	$(SANGO) -config config_ios.json -swift4 -verbose

build_android:
	@rm -rdf $(RESULTS_ANDROID)
	$(SANGO) -config config_android.json -verbose

build_all:
	set -e
	@$(MAKE) build_test_automation
	@$(MAKE) build_ios
	@$(MAKE) build_android


validate:
	$(SANGO) -verbose -input_assets '' -validate *.json
