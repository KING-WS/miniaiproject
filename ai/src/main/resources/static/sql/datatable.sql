CREATE TABLE llm_analysis_results (
                                      id BIGSERIAL PRIMARY KEY,
                                      input_data TEXT,
                                      llm_output JSONB,
                                      analysis_type VARCHAR(50),      -- 'expense', 'income', 'schedule'
                                      analysis_date DATE,
                                      amount NUMERIC(15, 2),
                                      category VARCHAR(100),
                                      description TEXT,
                                      model_name VARCHAR(100),
                                      model_version VARCHAR(50),
                                      analysis_timestamp TIMESTAMP WITH TIME ZONE,
                                      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                                      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);