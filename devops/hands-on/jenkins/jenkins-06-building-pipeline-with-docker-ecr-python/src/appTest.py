import unittest
import app
# unittest.TestLoader.sortTestMethodsUsing = None

class Test(unittest.TestCase):
    
    def test_0_insert(self):
        inserted_person = app.insert_mock_name("jason",5559990101)
        self.assertEqual(inserted_person, 'Person Jason added to Phonebook successfully')
    
    def test_1_insert_person(self):
        inserted_person = app.insert_person("jason",5559990101)
        self.assertEqual(inserted_person, 'Person Jason added to Phonebook successfully')
    
    def test_2_update_person(self):
        updated_person = app.update_person("jason",5559990102)
        self.assertEqual(updated_person, 'Phone record of Jason is updated successfully')
    
    def test_3_delete_person(self):
        deleted_person = app.delete_person("jason")
        self.assertEqual(deleted_person, 'Phone record of Jason is deleted from the phonebook successfully')

if __name__ == '__main__':
    unittest.main()