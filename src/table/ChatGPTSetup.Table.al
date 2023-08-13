table 50000 "ChatGPT Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';

        }
        field(10; "API Key"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'API Key';
        }
        field(20; "Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Temperature';
            DecimalPlaces = 1;
            MinValue = 0;
            MaxValue = 1;
        }

        field(30; "Max Token"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Token';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}