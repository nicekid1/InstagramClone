import {
  Injectable,
  Logger,
  Inject,
  OnModuleInit,
  forwardRef,
} from '@nestjs/common';
import * as amqp from 'amqplib';
import { ChatGateway } from '../chat/chat.gateway';

@Injectable()
export class RabbitMQService implements OnModuleInit  {
  private readonly logger = new Logger(RabbitMQService.name);
  private connection = amqp.connection;
  private channel = amqp.channel;
  constructor(
    @Inject(forwardRef(() => ChatGateway))
    private chatGateWay: ChatGateway,
  ) {}

  async onModuleInit() {
    //   this.logger.log('Attempting to connect to RabbitMQ...')


  }


  
}
