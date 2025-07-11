# generate_test_data.py
import pandas as pd

data = {
    "user_id": [1, 2],
    "name": ["Alice Smith", "Bob Jones"],
    "email": ["alice@example.com", "bob@example.com"],
    "registered_at": ["2024-12-10 10:00:00", "2025-01-15 15:30:00"]
}

df = pd.DataFrame(data)
df.to_excel("test_data.xlsx", index=False)

print("✅ test_data.xlsx generated successfully.")