package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.AddAlarmDto;

public interface AlarmRepository {
    public void save(AddAlarmDto addAlarmDto);
    public boolean isExist(int id);
    public String findById(int id);
    public void delete(int id);
}
