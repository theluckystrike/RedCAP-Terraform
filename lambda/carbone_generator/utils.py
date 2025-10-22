"""
Utility functions
"""
import json
from typing import Dict, Any


def format_success_response(data: Dict[str, Any]) -> Dict[str, Any]:
    """Format successful Lambda response"""
    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }


def format_error_response(status_code: int, message: str, details: Any = None) -> Dict[str, Any]:
    """Format error Lambda response"""
    body = {
        'error': message
    }
    if details:
        body['details'] = details
    
    return {
        'statusCode': status_code,
        'body': json.dumps(body)
    }