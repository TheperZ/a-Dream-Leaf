package com.DreamCoder.DreamLeaf.service;

import com.DreamCoder.DreamLeaf.dto.AddAlarmDto;
import com.DreamCoder.DreamLeaf.dto.AlarmExistDto;
import com.DreamCoder.DreamLeaf.repository.AlarmRepositoryImpl;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.OkHttpClient;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class AlarmService {

    private final AlarmRepositoryImpl alarmRepository;

    public String add(AddAlarmDto addAlarmDto) throws FirebaseMessagingException {
        int id = addAlarmDto.getUserId();
        if (alarmRepository.isExist(id)) {
            List<String> oldToken = new ArrayList<>();
            List<String> newToken = new ArrayList<>();
            oldToken.add(alarmRepository.findById(id));
            newToken.add(addAlarmDto.getFCMToken());
            TopicManagementResponse response = FirebaseMessaging.getInstance().unsubscribeFromTopic(
                    oldToken, "account"
            );
            System.out.println(response.getSuccessCount() + " tokens were unsubscribed successfully");
            response = FirebaseMessaging.getInstance().subscribeToTopic(
                    newToken, "account");
            System.out.println(response.getSuccessCount() + " tokens were subscribed successfully");
        } else {
            List<String> newToken = new ArrayList<>();
            newToken.add(addAlarmDto.getFCMToken());
            TopicManagementResponse response = FirebaseMessaging.getInstance().subscribeToTopic(
                    newToken, "account");
            System.out.println(response.getSuccessCount() + " tokens were subscribed successfully");
        }
        alarmRepository.save(addAlarmDto);
        return "알림이 설정 되었습니다.";
    }

    public String delete(int id) throws FirebaseMessagingException {
        String token = alarmRepository.findById(id);
        List<String> tokens = new ArrayList<>();
        tokens.add(token);
        TopicManagementResponse response = FirebaseMessaging.getInstance().unsubscribeFromTopic(
                tokens, "account"
        );
        System.out.println(response.getSuccessCount() + " tokens were unsubscribed successfully");
        alarmRepository.delete(id);
        return "알림이 해제 되었습니다.";
    }

    public AlarmExistDto isExist(int id) {
        boolean result = alarmRepository.isExist(id);
        AlarmExistDto alarmExistDto = new AlarmExistDto(result);
        return alarmExistDto;
    }

    @Scheduled(cron = "0 0 20 * * *")
    public void sending() throws FirebaseMessagingException {
        String topic = "account";
        Message message = Message.builder().setNotification(
                        Notification.builder()
                                .setTitle("오늘의 가계부! 작성하셨나요?")
                                .setBody("하루가 마무리 되어가고 있습니다! 좋은 하루 되셨나요? 오늘의 가계부를 작성해주세요!")
                                .build())
                .setTopic(topic)
                .build();
        String response = FirebaseMessaging.getInstance().send(message);
        System.out.println("Successfully sent message: " + response);
    }

}
