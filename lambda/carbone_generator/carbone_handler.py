"""
Carbone document generation handler
"""
import requests
import logging
from typing import Dict, Any
from config import Config

logger = logging.getLogger()


class CarboneHandler:
    """Handle Carbone document generation"""
    
    def __init__(self, config: Config):
        self.config = config
        self.endpoint = config.CARBONE_ENDPOINT
        
        logger.info(f"🔧 Carbone Handler initialized")
        logger.info(f"   Endpoint: {self.endpoint}")
    
    def generate_document(
        self,
        template_path: str,
        data: Dict[str, Any],
        output_format: str = 'pdf'
    ) -> bytes:
        """
        Generate document using Carbone EC2 service
        
        Args:
            template_path: Path to template file
            data: Data dictionary to merge
            output_format: Output format (pdf, docx, xlsx)
            
        Returns:
            Document bytes
        """
        logger.info(f"📝 Generating document (format: {output_format})...")
        
        try:
            import json
            
            with open(template_path, 'rb') as f:
                response = requests.post(
                    f"{self.endpoint}/render",
                    files={'template': f},
                    data={
                        'data': json.dumps(data),
                        'convertTo': output_format
                    },
                    timeout=120
                )
            
            if response.status_code != 200:
                raise Exception(f"Carbone generation failed: {response.text}")
            
            logger.info(f"✅ Document generated ({len(response.content)} bytes)")
            return response.content
            
        except requests.exceptions.Timeout:
            logger.error("❌ Carbone request timed out")
            raise Exception("Carbone request timed out")
        except Exception as e:
            logger.error(f"❌ Document generation failed: {str(e)}")
            raise