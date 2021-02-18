class ParticipantInfoScreenArguments {
  final String title;
  final String infoText;

  ParticipantInfoScreenArguments(this.title, this.infoText);
}

class IdeaOverviewScreenArguments {
  final int ideaId;
  final String authorInvitationCode;
  IdeaOverviewScreenArguments(this.ideaId, this.authorInvitationCode);
}

class ProjectOverviewScreenArguments {
  final int projectId;

  ProjectOverviewScreenArguments(this.projectId);
}