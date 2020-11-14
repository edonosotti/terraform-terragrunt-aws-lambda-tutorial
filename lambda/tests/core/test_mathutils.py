import unittest

from core import mathutils

class Test_mathutils(unittest.TestCase):
    def test_get_zeros(self):
        result = mathutils.get_zeros()
        self.assertEqual(len(result), 2)
        for item in result:
            self.assertEqual(len(item), 2)
