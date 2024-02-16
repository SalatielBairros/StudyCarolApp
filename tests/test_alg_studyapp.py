"""
Test Suite for alg_studyapp
"""
import unittest
from pycarol.app.online_request import OnlineRequest
from unittest.mock import MagicMock, patch

import src
from src import alg_studyapp


class TestAlgStudyapp(unittest.TestCase):
    def setUp(self):
        """Setup all variables mocks and things for all test steps
        """
        return super().setUp()

    def test_hello_world(self):
        """Test the /api/hello_world endpoint
        """
        return_value = alg_studyapp.hello_world()
        self.assertDictEqual(return_value, {'message': 'Hello World'})

    def test_sum(self):
        """Test the /api/sum endpoint
        """
        alg_studyapp.request = OnlineRequest(json={'a': 1,'b': 2})
        return_value = alg_studyapp.sum()
        self.assertEqual(return_value, {'sum': 3})

    def test_sum_error(self):
        """Test the /api/sum endpoint with error
        """
        alg_studyapp.request = OnlineRequest(json={'a': 'b'})
        return_value = alg_studyapp.sum()
        self.assertEqual(return_value, {'sum': 0})

    def test_main(self):
        """Test if OnLineAPI is executed correctly
        """
        with patch.object(alg_studyapp, "__name__", "__main__"):
            alg_studyapp.application.run = MagicMock()
            alg_studyapp.main()
            alg_studyapp.application.run.assert_called_with(debug=True, host='0.0.0.0')

    def tearDown(self):
        """Undo all things setted up for those tests
        """
        return super().tearDown()
