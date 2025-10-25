"""
Carbone Handler Module
Handles document generation using Carbone EE API
"""

import requests
import json


class CarboneHandler:
    """Handler for Carbone document generation API"""
    
    def __init__(self, endpoint):
        """
        Initialize Carbone handler with endpoint
        
        Args:
            endpoint: Carbone API endpoint URL (string or config object)
        """
        if isinstance(endpoint, str):
            self.carbone_endpoint = endpoint.rstrip('/')
        else:
            # Handle config object
            self.carbone_endpoint = str(endpoint).rstrip('/')
        
        print(f"🔧 Carbone Handler Initialized")
        print(f"   Endpoint: {self.carbone_endpoint}")
    
    def generate_document(self, template_bytes, data, output_format='pdf'):
        """
        Generate document using Carbone EE API (three-step process)
        
        Step 1: Upload template to Carbone → get templateId
        Step 2: Render document with data → get renderId  
        Step 3: Retrieve the actual generated document using renderId
        
        Args:
            template_bytes: Template file as bytes
            data: Dictionary containing data to populate the template
            output_format: Output format (default: 'pdf')
            
        Returns:
            bytes: Generated document as bytes
            
        Raises:
            Exception: If any step in the process fails
        """
        try:
            # ===== STEP 1: Upload Template =====
            print(f"\n{'='*70}")
            print(f"📤 STEP 1: Uploading Template to Carbone")
            print(f"{'='*70}")
            
            files = {
                'template': ('template.odt', template_bytes, 
                           'application/vnd.oasis.opendocument.text')
            }
            
            upload_response = requests.post(
                f"{self.carbone_endpoint}/template",
                files=files,
                timeout=30
            )
            
            print(f"   Status Code: {upload_response.status_code}")
            
            if not upload_response.ok:
                error_msg = f"Template upload failed with status {upload_response.status_code}"
                print(f"❌ {error_msg}")
                print(f"   Response: {upload_response.text}")
                raise Exception(error_msg)
            
            # Parse upload response
            upload_data = upload_response.json()
            
            if not upload_data.get('success'):
                error_msg = f"Upload unsuccessful: {upload_data}"
                print(f"❌ {error_msg}")
                raise Exception(error_msg)
            
            template_id = upload_data['data']['templateId']
            print(f"✅ Template Uploaded Successfully")
            print(f"   Template ID: {template_id}")
            
            # ===== STEP 2: Render Document =====
            print(f"\n{'='*70}")
            print(f"📄 STEP 2: Rendering Document with Data")
            print(f"{'='*70}")
            print(f"   Output Format: {output_format}")
            print(f"   Data Fields: {len(data)} fields")
            print(f"   Sample Fields: {list(data.keys())[:10]}")
            
            render_payload = {
                'data': data,
                'convertTo': output_format
            }
            
            render_response = requests.post(
                f"{self.carbone_endpoint}/render/{template_id}",
                json=render_payload,
                timeout=120
            )
            
            print(f"   Status Code: {render_response.status_code}")
            
            if not render_response.ok:
                error_msg = f"Render failed with status {render_response.status_code}"
                print(f"❌ {error_msg}")
                print(f"   Response: {render_response.text}")
                raise Exception(error_msg)
            
            # Parse render response to get renderId
            render_data = render_response.json()
            
            if not render_data.get('success'):
                error_msg = f"Render unsuccessful: {render_data}"
                print(f"❌ {error_msg}")
                raise Exception(error_msg)
            
            render_id = render_data['data']['renderId']
            print(f"✅ Document Rendered Successfully")
            print(f"   Render ID: {render_id}")
            
            # ===== STEP 3: Retrieve Generated Document =====
            print(f"\n{'='*70}")
            print(f"📥 STEP 3: Retrieving Generated Document")
            print(f"{'='*70}")
            
            retrieve_response = requests.get(
                f"{self.carbone_endpoint}/render/{render_id}",
                timeout=60
            )
            
            print(f"   Status Code: {retrieve_response.status_code}")
            
            if not retrieve_response.ok:
                error_msg = f"Document retrieval failed with status {retrieve_response.status_code}"
                print(f"❌ {error_msg}")
                print(f"   Response: {retrieve_response.text[:500]}")
                raise Exception(error_msg)
            
            # Get the document bytes
            document_bytes = retrieve_response.content
            content_type = retrieve_response.headers.get('Content-Type', 'unknown')
            
            print(f"✅ Document Retrieved Successfully")
            print(f"   Size: {len(document_bytes):,} bytes ({len(document_bytes)/1024:.2f} KB)")
            print(f"   Content-Type: {content_type}")
            print(f"{'='*70}\n")
            
            return document_bytes
            
        except requests.exceptions.Timeout as e:
            error_msg = f"Request timeout: {str(e)}"
            print(f"❌ {error_msg}")
            raise Exception(error_msg)
            
        except requests.exceptions.ConnectionError as e:
            error_msg = f"Connection error to Carbone: {str(e)}"
            print(f"❌ {error_msg}")
            raise Exception(error_msg)
            
        except requests.exceptions.RequestException as e:
            error_msg = f"Network error: {str(e)}"
            print(f"❌ {error_msg}")
            raise Exception(error_msg)
            
        except json.JSONDecodeError as e:
            error_msg = f"Failed to parse Carbone response as JSON: {str(e)}"
            print(f"❌ {error_msg}")
            raise Exception(error_msg)
            
        except KeyError as e:
            error_msg = f"Missing expected field in Carbone response: {str(e)}"
            print(f"❌ {error_msg}")
            raise Exception(error_msg)
            
        except Exception as e:
            error_msg = f"Unexpected error in generate_document: {str(e)}"
            print(f"❌ {error_msg}")
            raise